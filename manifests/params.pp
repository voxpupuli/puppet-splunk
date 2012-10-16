class splunk::params {

  $admin_port          = '8000'
  $deploy              = $::splunk_deploy #valid values are server, syslog, forwarder
  $linux_stage_dir     = "/usr/local/installers"
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
      $package_suffix = "${splunk_ver}.i386.rpm"
    }
    "RedHat x86_64": {
      $package_suffix = "${splunk_ver}-linux-2.6-x86_64.rpm"
    }
    "Debian i386": {
      $package_suffix = "${splunk_ver}-linux-2.6-intel.deb"
    }
    "Debian x86_64": {
      $package_suffix = "${splunk_ver}-linux-2.6-amd64.deb"
    }
    /^(W|w)indows (x86|i386)$/: {
      $package_suffix = "${splunk_ver}-x86-release.msi"
    }
    /^(W|w)indows (x64|x86_64)$/: {
      $package_suffix = "${splunk_ver}-x64-release.msi"
    }
    default: {
      fail("osfamily/architecture $::osfamily/$::architecture not supported")
    }
  }

  $splunk_package_name = "splunk-$package_suffix"
  $splunkforwarder_package_name = "splunkforwarder-$package_suffix"

  case $deploy {
    'server':    { $installer = $splunk_package_name }
    'forwarder': { $installer = $splunkforwarder_package_name }
  }

  $installer_source = "${source_root}/${installer}"

}
