# Class: splunk::platform::posix::forwarder
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
class splunk::platform::posix::forwarder (
  $splunkd_port = $splunk::splunkd_port,
  $splunk_user = $splunk::params::splunk_user,
) inherits splunk::virtual {

  include ::splunk::params
  class {'::splunk::platform::posix':
    splunkd_port => $splunkd_port,
    splunk_user  => $splunk_user,
  }
  # Many of the resources declared here are virtual. They will be realized by
  # the appropriate including class if required.

  # Commands to run to enable the SplunkUniversalForwarder
  @exec { 'license_splunkforwarder':
    path    => "${splunk::params::forwarder_dir}/bin",
    command => 'splunk start --accept-license --answer-yes',
    user    => $splunk_user,
    creates => '/opt/splunkforwarder/etc/auth/server.pem',
    timeout => 0,
    tag     => 'splunk_forwarder',
  }
  @exec { 'enable_splunkforwarder':

    # The path parameter can't be set because the boot-start silently fails on systemd service providers
    command => "${splunk::params::forwarder_dir}/bin/splunk enable boot-start -user ${splunk_user}",
    creates => '/etc/init.d/splunk',
    require => Exec['license_splunkforwarder'],
    tag     => 'splunk_forwarder',
  }

}
