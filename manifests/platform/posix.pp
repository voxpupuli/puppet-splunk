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
  $splunk_user = $splunk::params::splunk_user,
) inherits splunk::virtual {

  include ::splunk::params

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
    pattern  => 'python -O /opt/splunk/lib/python.*/splunk/.*/root.py.*',
    require  => Service['splunk'],
  }

}
