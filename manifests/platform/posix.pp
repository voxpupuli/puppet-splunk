# Class: splunk::platform::posix
#
# This class declares virtual resources and collects existing virtual
# resources for adjustment appropriate to deployment on a Posix host.
# It extends functionality of either splunk, splunk::forwarder, or
# both.
#
# Parameters: none
#
# Actions:
#
#   Declares, tags, and modifies virtual resources realized by other classes
#   in the splunk module.
#
# Requires: nothing
#
class splunk::platform::posix (
  $splunkd_port = undef,
  $server_service = undef,
  $splunk_user = $splunk::params::splunk_user,
  $service_file = $splunk::params::service_file,
) inherits splunk::virtual {

  include ::splunk::params
  # Many of the resources declared here are virtual. They will be realized by
  # the appropriate including class if required.

  # Commands to run to enable the SplunkUniversalForwarder
  if $splunk::params::boot_start {
    @exec { 'enable_splunkforwarder':
      command => "${splunk::params::forwarder_dir}/bin/splunk enable boot-start -user ${splunk_user} --accept-license --answer-yes --no-prompt",
      creates => $service_file,
      tag     => 'splunk_forwarder',
      notify  => Service[$splunk::params::server_service],
    }
  }
  else {
    @exec { 'license_splunkforwarder':
      path    => "${splunk::params::forwarder_dir}/bin",
      command => 'splunk ftr --accept-license --answer-yes --no-prompt',
      user    => $splunk_user,
      onlyif  => "/usr/bin/test -f ${splunk::params::forwarder_dir}/ftr",
      timeout => 0,
      tag     => 'splunk_forwarder',
      notify  => Service[$splunk::params::server_service],
    }
  }

  # Commands to run to enable full Splunk
  if $splunk::params::boot_start {
    @exec { 'enable_splunk':
      command => "${splunk::params::server_dir}/bin/splunk enable boot-start -user ${splunk_user} --accept-license --answer-yes --no-prompt",
      creates => $service_file,
      tag     => 'splunk_server',
      before  => Service[$splunk::params::server_service],
    }
  }
  else {
    @exec { 'license_splunk':
      path    => "${splunk::params::server_dir}/bin",
      command => 'splunk start --accept-license --answer-yes --no-prompt',
      user    => $splunk_user,
      creates => "${splunk::params::server_dir}/etc/auth/splunk.secret",
      timeout => 0,
      tag     => 'splunk_server',
    }
  }

  # Modify virtual service definitions specific to the Linux platform. These
  # are virtual resources declared in the splunk::virtual class, which we
  # inherit.
  # The following code will only execute if splunk is not configured to start
  # at boot.  The default is to use the system startup script.
  if $splunk::params::boot_start == false {
    if $splunk::params::legacy_mode == true {
      Service['splunkweb'] {
        provider => 'base',
        restart  => "${splunk::params::server_dir}/bin/splunk restart splunkweb",
        start    => "${splunk::params::server_dir}/bin/splunk start splunkweb",
        stop     => "${splunk::params::server_dir}/bin/splunk stop splunkweb",
        pattern  => 'python -O /opt/splunk/lib/python.*/splunk/.*/root.py.*',
      }
      Service['splunkd'] {
        provider => 'base',
        restart  => "${splunk::params::server_dir}/bin/splunk restart splunkd",
        start    => "${splunk::params::server_dir}/bin/splunk start splunkd",
        stop     => "${splunk::params::server_dir}/bin/splunk stop splunkd",
        pattern  => "splunkd -p ${splunkd_port} (restart|start)",
      }
    }
    else {
      Service[$server_service] {
        provider => 'base',
        restart  => "${splunk::params::server_dir}/bin/splunk restart",
        start    => "${splunk::params::server_dir}/bin/splunk start",
        stop     => "${splunk::params::server_dir}/bin/splunk stop",
        pattern  => "splunkd -p ${splunkd_port} (restart|start)",
      }

    }
  }
}
