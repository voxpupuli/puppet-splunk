# @summary
#   Contains or define through additional platform specific sub-classes, the
#   steps for installing the Splunk Universal Forwarder
#
class splunk::forwarder::install {
  $_package_source = $splunk::forwarder::manage_package_source ? {
    true  => $splunk::forwarder::forwarder_package_src,
    false => $splunk::forwarder::package_source
  }

  if $splunk::forwarder::package_provider and !($splunk::forwarder::package_provider in ['apt','chocolatey','yum']) {
    $_src_package_filename = basename($_package_source)
    $_package_path_parts   = [$splunk::forwarder::staging_dir, $_src_package_filename]
    $_staged_package       = join($_package_path_parts, $splunk::forwarder::path_delimiter)

    archive { $_staged_package:
      source         => $_package_source,
      extract        => false,
      allow_insecure => $splunk::forwarder::allow_insecure,
      before         => Package[$splunk::forwarder::forwarder_package_name],
    }
  } else {
    $_staged_package = undef
  }

  Package {
    source         => $splunk::forwarder::package_provider ? {
      'chocolatey' => undef,
      default      => $splunk::forwarder::manage_package_source ? {
        true  => pick($_staged_package, $_package_source),
        false => $_package_source,
      }
    },
  }

  if $facts['kernel'] == 'SunOS' {
    $_responsefile = "${splunk::forwarder::staging_dir}/response.txt"
    $_adminfile    = '/var/sadm/install/admin/splunk-noask'

    file { 'splunk_adminfile':
      ensure => file,
      path   => $_adminfile,
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/splunk/splunk-noask',
    }

    file { 'splunk_pkg_response_file':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      path    => $_responsefile,
      content => "BASEDIR=/opt\n",
    }

    # Collect any Splunk packages and give them an admin and response file.
    Package {
      adminfile    => $_adminfile,
      responsefile => $_responsefile,
    }
  }

  # Required for splunk from 7.2.4.2 until 8.0.0
  if (
    $splunk::params::manage_net_tools and
    $facts['kernel'] == 'Linux' and
    versioncmp($splunk::forwarder::version, '7.2.4.2') >= 0 and
    versioncmp($splunk::forwarder::version, '8.0.0') == -1
  ) {
    stdlib::ensure_packages(['net-tools'],
      {
        'ensure' => 'present',
      },
    )
    Package['net-tools'] -> Package[$splunk::forwarder::package_name]
  }

  package { $splunk::forwarder::package_name:
    ensure          => $splunk::forwarder::package_ensure,
    provider        => $splunk::forwarder::package_provider,
    install_options => $splunk::forwarder::install_options,
  }

  if $facts['kernel'] == 'Linux' and $facts['service_provider'] == 'systemd' and $splunk::forwarder::boot_start {
    if $facts['splunkforwarder_version'] and versioncmp($facts['splunkforwarder_version'], $splunk::forwarder::version) != 0 {
      $_splunk_home = $splunk::forwarder::forwarder_homedir
      $_splunk_user = $splunk::forwarder::splunk_user

      case $facts['os']['family'] {
        'RedHat', 'Suse': {
          $_staged_file = "${splunk::forwarder::staging_dir}/splunkforwarder-${splunk::forwarder::version}-*.x86_64.rpm"
          $_install_cmd = "/bin/rpm -U --force ${_staged_file}"
        }
        'Debian': {
          $_staged_file = "${splunk::forwarder::staging_dir}/splunkforwarder-${splunk::forwarder::version}-*-amd64.deb"
          $_install_cmd = "/usr/bin/dpkg -i ${_staged_file}"
        }
        default: {
          $_staged_file = undef
          $_install_cmd = undef
        }
      }

      exec { 'splunkforwarder-disable-boot-start':
        command => "${_splunk_home}/bin/splunk disable boot-start -user ${_splunk_user} --accept-license --answer-yes --no-prompt || true",
        onlyif  => "/usr/bin/test -f ${_splunk_home}/bin/splunk",
        timeout => 120,
      }

      exec { 'splunkforwarder-stop-for-upgrade':
        command => "${_splunk_home}/bin/splunk stop",
        onlyif  => "/usr/bin/test -f ${_splunk_home}/bin/splunk",
        timeout => 120,
      }

      if $_staged_file and $_install_cmd {
        exec { 'splunkforwarder-install-package':
          command => $_install_cmd,
          onlyif  => "ls ${_staged_file}",
          timeout => 300,
        }

        exec { 'splunkforwarder-enable-boot-start-after-upgrade':
          command => "${_splunk_home}/bin/splunk enable boot-start -user ${_splunk_user} -group ${_splunk_user} --accept-license --answer-yes --no-prompt",
          onlyif  => "/usr/bin/test -f ${_splunk_home}/bin/splunk",
          returns => [0, 4],
          timeout => 120,
        }

        exec { 'splunkforwarder-fix-ownership':
          command => "/bin/chown -R ${_splunk_user}:${_splunk_user} ${_splunk_home}",
          onlyif  => "/usr/bin/test -d ${_splunk_home}",
          timeout => 120,
        }

        Exec['splunkforwarder-enable-boot-start-after-upgrade'] -> Exec['splunkforwarder-fix-ownership']

        Exec['splunkforwarder-disable-boot-start'] -> Exec['splunkforwarder-stop-for-upgrade'] -> Exec['splunkforwarder-install-package'] -> Exec['splunkforwarder-enable-boot-start-after-upgrade']
      }
    }

    $_splunk_home_always = $splunk::forwarder::forwarder_homedir
    $_splunk_user_always = $splunk::forwarder::splunk_user

    exec { 'splunkforwarder-fix-ownership-always':
      command => "/bin/chown -R ${_splunk_user_always}:${_splunk_user_always} ${_splunk_home_always}",
      onlyif  => "/usr/bin/test -d ${_splunk_home_always} && /usr/bin/stat -c '%G' ${_splunk_home_always} | grep -v '^${_splunk_user_always}$'",
      timeout => 120,
    }
  }
}
