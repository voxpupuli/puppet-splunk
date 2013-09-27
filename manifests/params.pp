class splunk::params (
  $version      = '4.3.2',
  $build        = '123586',
  $admin_port   = '8000',
  $splunkd_port = '8089',
  $logging_port = '9997',
  $src_root     = "puppet:///modules/splunk/releases/4.3.2",
) {

  # Based on the small number of inputs above, we can construct sane defaults
  # for pretty much everything else.

  case "$::osfamily $::architecture" {
    "RedHat i386": {
      $forwarder_src_subdir = 'universalforwarder/linux'
      $forwarder_src_pkg    = "splunkforwarder-${version}-${build}.i386.rpm"
      $forwarder_pkg_name   = "splunkforwarder-${version}-${build}"
      $forwarder_service    = 'splunk'
      $forwarder_confdir    = '/opt/splunkforwarder/etc/system/local'

      $server_src_subdir    = 'splunk/linux'
      $server_src_pkg       = "splunk-${version}-${build}.i386.rpm"
      $server_pkg_name      = "splunk-${version}-${build}"
      $server_service       = 'splunk'
      $server_confdir       = '/opt/splunk/etc/system/local'

      $pkg_provider         = 'rpm'
    }
    "RedHat x86_64": {
      $forwarder_src_subdir = 'universalforwarder/linux'
      $forwarder_src_pkg    = "splunkforwarder-${version}-${build}-linux-2.6-x86_64.rpm"
      $forwarder_pkg_name   = "splunkforwarder-${version}-${build}"
      $forwarder_service    = 'splunk'
      $forwarder_confdir    = '/opt/splunkforwarder/etc/system/local'

      $server_src_subdir    = 'splunk/linux'
      $server_src_pkg       = "splunk-${version}-${build}-linux-2.6-x86_64.rpm"
      $server_pkg_name      = "splunk-${version}-${build}"
      $server_service       = 'splunk'
      $server_confdir       = '/opt/splunk/etc/system/local'

      $pkg_provider         = 'rpm'
    }
    "Debian i386": {
      $package_suffix           = "${splunk_ver}-linux-2.6-intel.deb"
      $pkg_provider             = 'dpkg'
      $splunk_pkg_name          = "splunk"
      $splunkforwarder_pkg_name = "splunkforwarders"
    }
    "Debian x86_64": {
      $package_suffix           = "${splunk_ver}-linux-2.6-amd64.deb"
      $pkg_provider             = 'dpkg'
      $splunk_pkg_name          = "splunk"
      $splunkforwarder_pkg_name = "splunkforwarders"
    }
    /^(W|w)indows (x86|i386)$/: {
      $package_suffix = "${splunk_ver}-x86-release.msi"
    }
    /^(W|w)indows (x64|x86_64)$/: {
      $package_suffix = "${splunk_ver}-x64-release.msi"
    }
    "Solaris i86pc": {
      $package_suffix = "${splunk_ver}-solaris-9-intel.pkg"
    }
    default: {
      fail("osfamily/architecture $::osfamily/$::architecture not supported")
    }
  }

  $splunk_pkg = "splunk-$package_suffix"
  $splunkforwarder_pkg = "splunkforwarder-$package_suffix"

  $server_pkg_src    = "${src_root}/${server_src_subdir}/${server_src_pkg}"
  $forwarder_pkg_src = "${src_root}/${forwarder_src_subdir}/${forwarder_src_pkg}"

}
