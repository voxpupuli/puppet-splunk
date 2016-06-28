# Class: splunk::platform::posix::server
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
class splunk::platform::posix::server {

  include ::splunk::params
  include ::splunk::platform::posix

  # Many of the resources declared here are virtual. They will be realized by
  # the appropriate including class if required.

  # Commands to run to enable full Splunk
  @exec { 'license_splunk':
    path    => "${splunk::params::server_dir}/bin",
    command => 'splunk start --accept-license --answer-yes',
    user    => $splunk_user,
    creates => '/opt/splunk/etc/auth/splunk.secret',
    timeout => 0,
    tag     => 'splunk_server',
  }
  @exec { 'enable_splunk':
    # The path parameter can't be set because the boot-start silently fails on systemd service providers
    command => "${splunk::params::server_dir}/bin/splunk enable boot-start -user ${splunk_user}",
    creates => '/etc/init.d/splunk',
    require => Exec['license_splunk'],
    tag     => 'splunk_server',
  }

}
