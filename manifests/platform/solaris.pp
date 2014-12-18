# Class: splunk::platform::solaris
#
# This class extends splunk::platform::posix with Solaris-specific resources
# required for deploying Splunk to a solaris host.
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
class splunk::platform::solaris inherits splunk::virtual {
  include staging
  include splunk::params
  include splunk::platform::posix

  $path         = $staging::path
  $subdir       = $splunk::params::staging_subdir
  $responsefile = "${path}/${subdir}/response.txt"
  $adminfile    = '/var/sadm/install/admin/splunk-noask'

  file { 'splunk_adminfile':
    ensure => file,
    path   => $adminfile,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/splunk/splunk-noask',
  }

  file { 'splunk_pkg_response_file':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    path    => $responsefile,
    content => "BASEDIR=/opt\n",
  }

  # Collect any Splunk packages and give them an admin and response file.
  Package <| tag == 'splunk_forwarder' or tag == 'splunk_server' |> {
    adminfile    => $adminfile,
    responsefile => $responsefile,
  }

  # This is a virtual resource declared in the splunk::virtual class. We need
  # to override it since the default service provider on Solaris is not init.
  Service['splunk'] {
    provider => 'init',
  }

}
