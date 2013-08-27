class splunk::params {

  $admin_port          = '8000'
  $linux_stage_dir     = "/usr/local/installers"
  $solaris_stage_dir   = "/usr/local/installers"
  $logging_port        = $::splunk_forwarder_port
  $logging_server      = $::splunk_logging_server
  $source_root         = "puppet:///files/${module_name}"
  $splunk_admin        = "admin"
  $splunk_admin_pass   = "changeme"
  $splunk_ver          = '4.3.2-123586'
  $splunkd_port        = '8089'
  $syslogging_port     = $::splunk_syslog_port
  $windows_stage_drive = "C:"

  case "$::osfamily $::architecture" {
    "RedHat i386": {
      $package_suffix           = "${splunk_ver}.i386.rpm"
      $pkg_provider             = 'rpm'
      $splunk_pkg_name          = "splunk-${splunk_ver}.${::architecture}"
      $splunkforwarder_pkg_name = "splunkforwarders-${splunk_ver}.${::architecture}"
    }
    "RedHat x86_64": {
      $package_suffix           = "${splunk_ver}-linux-2.6-x86_64.rpm"
      $pkg_provider             = 'rpm'
      $splunk_pkg_name          = "splunk-${splunk_ver}.${::architecture}"
      $splunkforwarder_pkg_name = "splunkforwarders-${splunk_ver}.${::architecture}"
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

}
