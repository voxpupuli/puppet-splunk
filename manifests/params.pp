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

  # Settings common to everything
  $staging_subdir = 'splunk'

  # Settings common to a kernel
  case $::kernel {
    default: { fail("splunk module does not support kernel ${kernel}") }
    'Linux': {
      $path_delimiter       = '/'
      $forwarder_src_subdir = 'universalforwarder/linux'
      $forwarder_service    = [ 'splunk' ]
      $forwarder_confdir    = '/opt/splunkforwarder/etc/system/local'
      $server_src_subdir    = 'splunk/linux'
      $server_service       = [ 'splunk', 'splunkd', 'splunkweb' ]
      $server_confdir       = '/opt/splunk/etc/system/local'
    }
    'SunOS': {
      $path_delimiter       = '/'
      $forwarder_src_subdir = 'universalforwarder/solaris'
      $forwarder_service    = [ 'splunk' ]
      $forwarder_confdir    = '/opt/splunkforwarder/etc/system/local'
      $server_src_subdir    = 'splunk/solaris'
      $server_service       = [ 'splunk', 'splunkd', 'splunkweb' ]
      $server_confdir       = '/opt/splunk/etc/system/local'
    }
    'Windows': {
      $path_delimiter       = '\\'
      $forwarder_src_subdir = 'universalforwarder/windows'
      $forwarder_service    = [ 'SplunkForwarder' ] # UNKNOWN
      $forwarder_confdir    = 'C:/Program Files/SplunkUniversalForwarder/etc/system/local'
      $server_src_subdir    = 'splunk/windows'
      $server_service       = [ 'Splunk' ] # UNKNOWN
      $server_confdir       = 'C:/Program Files/Splunk/etc/system/local' # UNKNOWN
      $forwarder_install_options = [
        'AGREETOLICENSE=Yes',
        'LAUNCHSPLUNK=0',
        'SERVICESTARTTYPE=auto',
        'WINEVENTLOG_APP_ENABLE=1',
        'WINEVENTLOG_SEC_ENABLE=1',
        'WINEVENTLOG_SYS_ENABLE=1',
        'WINEVENTLOG_FWD_ENABLE=1',
        'WINEVENTLOG_SET_ENABLE=1',
        'ENABLEADMON=1',
      ]
      $server_install_options = [
        'LAUNCHSPLUNK=1',
        'WINEVENTLOG_APP_ENABLE=1',
        'WINEVENTLOG_SEC_ENABLE=1',
        'WINEVENTLOG_SYS_ENABLE=1',
        'WINEVENTLOG_FWD_ENABLE=1',
        'WINEVENTLOG_SET_ENABLE=1',
      ]
    }
  }

  # Settings common to an OS family
  case $::osfamily {
    default:   { $pkg_provider = undef  } # Don't define a $pkg_provider
    'RedHat':  { $pkg_provider = 'rpm'  }
    'Debian':  { $pkg_provider = 'dpkg' }
    'Solaris': { $pkg_provider = 'sun'  }
  }

  # Settings specific to an architecture as well as an OS family
  case "$::osfamily $::architecture" {
    default: { fail("unsupported osfamily/arch $::osfamily/$::architecture") }
    "RedHat i386": {
      $package_suffix       = "${version}-${build}.i386.rpm"
      $forwarder_pkg_name   = "splunkforwarder-${version}-${build}"
      $server_pkg_name      = "splunk-${version}-${build}"
    }
    "RedHat x86_64": {
      $package_suffix       = "${version}-${build}-linux-2.6-x86_64.rpm"
      $forwarder_pkg_name   = "splunkforwarder-${version}-${build}"
      $server_pkg_name      = "splunk-${version}-${build}"
    }
    "Debian i386": {
      $package_suffix       = "${version}-${build}-linux-2.6-intel.deb"
      $forwarder_pkg_name   = 'splunkforwarder'
      $server_pkg_name      = 'splunk'
    }
    "Debian amd64": {
      $package_suffix       = "${version}-${build}-linux-2.6-amd64.deb"
      $forwarder_pkg_name   = 'splunkforwarder'
      $server_pkg_name      = 'splunk'
    }
    /^(W|w)indows (x86|i386)$/: {
      $package_suffix       = "${version}-${build}-x86-release.msi"
      $forwarder_pkg_name   = 'Universal Forwarder'
      $server_pkg_name      = 'Splunk'
    }
    /^(W|w)indows (x64|x86_64)$/: {
      $package_suffix       = "${version}-${build}-x64-release.msi"
      $forwarder_pkg_name   = 'Universal Forwarder'
      $server_pkg_name      = 'Splunk'
    }
    "Solaris i86pc": {
      $package_suffix       = "${version}-${build}-solaris-9-intel.pkg"
      $forwarder_pkg_name   = 'splunkforwarder'
      $server_pkg_name      = 'splunk'
    }
  }

  $forwarder_src_pkg = "splunkforwarder-$package_suffix"
  $server_src_pkg    = "splunk-$package_suffix"

  $server_pkg_src    = "${src_root}/${server_src_subdir}/${server_src_pkg}"
  $forwarder_pkg_src = "${src_root}/${forwarder_src_subdir}/${forwarder_src_pkg}"

}
