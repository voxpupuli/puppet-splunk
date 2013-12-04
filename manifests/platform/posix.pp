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
  $splunkd_port = $splunk::splunkd_port,
) inherits splunk::virtual {

  # Many of the resources declared here are virtual. They will be realized by
  # the appropriate including class if required.

  # Commands to run to enable the SplunkUniversalForwarder
  @exec { 'license_splunkforwarder':
    path    => '/opt/splunkforwarder/bin',
    command => 'splunk start --accept-license --answer-yes',
    creates => '/opt/splunkforwarder/etc/auth/splunk.secret',
    timeout => 0,
    tag     => 'splunk_forwarder',
  }
  @exec { 'enable_splunkforwarder':
    path    => '/opt/splunkforwarder/bin',
    command => 'splunk enable boot-start',
    creates => '/etc/init.d/splunk',
    require => Exec['license_splunkforwarder'],
    tag     => 'splunk_forwarder',
  }

  # Commands to run to enable full Splunk
  @exec { 'license_splunk':
    path    => '/opt/splunk/bin',
    command => 'splunk start --accept-license --answer-yes',
    creates => '/opt/splunk/etc/auth/splunk.secret',
    timeout => 0,
    tag     => 'splunk_server',
  }
  @exec { 'enable_splunk':
    path    => '/opt/splunk/bin',
    command => 'splunk enable boot-start',
    creates => '/etc/init.d/splunk',
    require => Exec['license_splunk'],
    tag     => 'splunk_server',
  }

  # Default inputs/outputs to create on Linux systems
  @splunkforwarder_input { 'monitor_varlog':
    section => 'monitor://var/log/',
    setting => 'host',
    value   => $::clientcert,
    tag     => 'splunk_forwarder',
  }

  # Modify virtual service definitions specific to the Linux platform. These
  # are virtual resources declared in the splunk::virtual class, which we
  # inherit.
  Service['splunkd'] {
    provider => 'base',
    restart  => '/opt/splunk/bin/splunk restart splunkd',
    start    => '/opt/splunk/bin/splunk start splunkd',
    stop     => '/opt/splunk/bin/splunk stop splunkd',
    pattern  => "splunkd -p ${splunkd_port} (restart|start)",
    require  => Service['splunk'],
  }
  Service['splunkweb'] {
    provider => 'base',
    restart  => '/opt/splunk/bin/splunk restart splunkweb',
    start    => '/opt/splunk/bin/splunk start splunkweb',
    stop     => '/opt/splunk/bin/splunk stop splunkweb',
    pattern  => 'python -O /opt/splunk/lib/python.*/splunk/.*/root.py (restart|start)',
    require  => Service['splunk'],
  }

}
