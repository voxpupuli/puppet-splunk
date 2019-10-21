# @summary
#   Private class declared by Class[splunk::enterprise::service] to provide
#   platform specific service management on Linux or Unix type systems.
#
class splunk::enterprise::service::nix inherits splunk::enterprise::service {

  if $splunk::enterprise::boot_start {
    # Ensure splunk services *not* managed by the system service file are
    # gracefully shut down prior to enabling boot-start. Should the service
    # file be enabled while binary-managed splunk services are running, you
    # will no longer be able to control the binary-managed services
    # (start/stop/restart).
    exec { 'stop_splunk':
      command => "${splunk::enterprise::enterprise_homedir}/bin/splunk stop",
      user    => $splunk::enterprise::splunk_user,
      creates => $splunk::enterprise::enterprise_service_file,
      timeout => 0,
      notify  => Exec['enable_splunk'],
    }
    if $splunk::params::supports_systemd and $splunk::enterprise::splunk_user == 'root' {
      $user_args = ''
    } else {
      $user_args = "-user ${splunk::enterprise::splunk_user}"
    }
    # This will fail if the unit file already exists.  Splunk does not remove
    # unit files during uninstallation, so you may be required to manually
    # remove existing unit files before re-installing and enabling boot-start.
    exec { 'enable_splunk':
      command     => "${splunk::enterprise::enterprise_homedir}/bin/splunk enable boot-start ${user_args} ${splunk::params::boot_start_args} --accept-license --answer-yes --no-prompt",
      refreshonly => true,
      before      => Service[$splunk::enterprise::service_name],
      require     => Exec['stop_splunk'],
    }
  }
  # Commands to license, disable, and start Splunk Enterprise
  #
  else {
    # Accept the license when disabling splunk in case system service files are
    # present before installing splunk.  The splunk package does not remove the
    # service files when uninstalled.
    exec { 'disable_splunk':
      command => "${splunk::enterprise::enterprise_homedir}/bin/splunk disable boot-start -user ${splunk::enterprise::splunk_user} --accept-license --answer-yes --no-prompt",
      onlyif  => "/usr/bin/test -f ${splunk::enterprise::enterprise_service_file}",
    }
    # This will start splunkd and splunkweb in legacy mode assuming
    # appServerPorts is set to 0.
    exec { 'license_splunk':
      command => "${splunk::enterprise::enterprise_homedir}/bin/splunk start --accept-license --answer-yes --no-prompt",
      user    => $splunk::enterprise::splunk_user,
      creates => "${splunk::enterprise::enterprise_homedir}/etc/auth/splunk.secret",
      timeout => 0,
      before  => Service[$splunk::enterprise::service_name],
      require => Exec['disable_splunk'],
    }

    if $facts['kernel'] == 'Linux' {
      Service[$splunk::enterprise::service_name] {
        provider => 'base',
      }
    }
    else {
      Service[$splunk::enterprise::service_name] {
        provider => 'init',
      }
    }
    Service[$splunk::enterprise::service_name] {
      restart  => "/usr/sbin/runuser -l ${splunk::enterprise::splunk_user} -c '${splunk::enterprise::enterprise_homedir}/bin/splunk restart'",
      start    => "/usr/sbin/runuser -l ${splunk::enterprise::splunk_user} -c '${splunk::enterprise::enterprise_homedir}/bin/splunk start'",
      stop     => "/usr/sbin/runuser -l ${splunk::enterprise::splunk_user} -c '${splunk::enterprise::enterprise_homedir}/bin/splunk stop'",
      status   => "/usr/sbin/runuser -l ${splunk::enterprise::splunk_user} -c '${splunk::enterprise::enterprise_homedir}/bin/splunk status'",
      pattern  => "splunkd -p ${splunk::enterprise::splunkd_port} (restart|start)",
    }
  }

}
