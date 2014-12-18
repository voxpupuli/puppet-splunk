# Class: splunk::params
#
# This class takes a small number of arguments (can be set through Hiera) and
# generates sane default values installation media names and locations. Default
# ports can also be specified here. This is a parameters class, and contributes
# no resources to the graph. Rather, it only sets values for parameters to be
# consumed by child classes.
#
# Parameters:
#
# [*version*]
#   The version of Splunk to install. This will be in the form x.y.z; e.g.
#   "4.3.2".
#
# [*build*]
#   Splunk packages are typically named based on the platform, architecture,
#   version, and build. Puppet can determine the platform information
#   automatically but a build number must be supplied in order to correctly
#   construct the path to the packages. A build number will be six digits;
#   e.g. "123586".
#
# [*splunkd_port*]
#   The splunkd port. Used as a default for both splunk and splunk::forwarder.
#
# [*logging_port*]
#   The port on which to send logs, and listen for logs. Used as a default for
#   splunk and splunk::forwarder.
#
# [*src_root*]
#   The root URL at which to find the splunk packages. The sane-default logic
#   assumes that the packages are located under this URL in the same way that
#   they are placed on download.splunk.com. The URL can be any protocol that
#   the nanliu/staging module supports. This includes both puppet:// and
#   http://.  The expected directory structure is:
#
#     `-- $root_url
#         |-- splunk
#         |   `-- $platform
#         |       `-- splunk-${version}-${build}-${additl}
#         `-- universalforwarder
#             `-- $platform
#                 `-- splunkforwarder-${version}-${build}-${additl}
#
#   A semi-populated example src_root then contain:
#
#     `-- $root_url
#         |-- splunk
#         |   `-- linux
#         |       |-- splunk-4.3.2-123586-linux-2.6-amd64.deb
#         |       |-- splunk-4.3.2-123586-linux-2.6-intel.deb
#         |       `-- splunk-4.3.2-123586-linux-2.6-x86_64.rpm
#         `-- universalforwarder
#             |-- linux
#             |   |-- splunkforwarder-4.3.2-123586-linux-2.6-amd64.deb
#             |   |-- splunkforwarder-4.3.2-123586-linux-2.6-intel.deb
#             |   `-- splunkforwarder-4.3.2-123586-linux-2.6-x86_64.rpm
#             |-- solaris
#             |   `-- splunkforwarder-4.3.2-123586-solaris-10-intel.pkg
#             `-- windows
#                 |-- splunkforwarder-4.3.2-123586-x64-release.msi
#                 `-- splunkforwarder-4.3.2-123586-x86-release.msi
#
# Actions:
#
#   Declares parameters to be consumed by other classes in the splunk module.
#
# Requires: nothing
#
class splunk::params (
  $version      = '5.0.5',
  $build        = '179365',
  $src_root     = 'puppet:///modules/splunk',
  $splunkd_port = '8089',
  $logging_port = '9997',
) {

  # Based on the small number of inputs above, we can construct sane defaults
  # for pretty much everything else.

  # Settings common to everything
  $staging_subdir = 'splunk'

  # Settings common to a kernel
  case $::kernel {
    default: { fail("splunk module does not support kernel ${::kernel}") }
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
      $server_service       = [ 'Splunkd', 'Splunkweb' ] # UNKNOWN
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
  case "${::osfamily} ${::architecture}" {
    default: { fail("unsupported osfamily/arch ${::osfamily}/${::architecture}") }
    'RedHat i386': {
      $package_suffix       = "${version}-${build}.i386.rpm"
      $forwarder_pkg_name   = 'splunkforwarder'
      $server_pkg_name      = 'splunk'
    }
    'RedHat x86_64': {
      $package_suffix       = "${version}-${build}-linux-2.6-x86_64.rpm"
      $forwarder_pkg_name   = 'splunkforwarder'
      $server_pkg_name      = 'splunk'
    }
    'Debian i386': {
      $package_suffix       = "${version}-${build}-linux-2.6-intel.deb"
      $forwarder_pkg_name   = 'splunkforwarder'
      $server_pkg_name      = 'splunk'
    }
    'Debian amd64': {
      $package_suffix       = "${version}-${build}-linux-2.6-amd64.deb"
      $forwarder_pkg_name   = 'splunkforwarder'
      $server_pkg_name      = 'splunk'
    }
    /^(W|w)indows (x86|i386)$/: {
      $package_suffix       = "${version}-${build}-x86-release.msi"
      $forwarder_pkg_name   = 'UniversalForwarder'
      $server_pkg_name      = 'Splunk'
    }
    /^(W|w)indows (x64|x86_64)$/: {
      $package_suffix       = "${version}-${build}-x64-release.msi"
      $forwarder_pkg_name   = 'UniversalForwarder'
      $server_pkg_name      = 'Splunk'
    }
    'Solaris i86pc': {
      $package_suffix       = "${version}-${build}-solaris-10-intel.pkg"
      $forwarder_pkg_name   = 'splunkforwarder'
      $server_pkg_name      = 'splunk'
    }
    'Solaris sun4v': {
      $package_suffix       = "${version}-${build}-solaris-8-sparc.pkg"
      $forwarder_pkg_name   = 'splunkforwarder'
      $server_pkg_name      = 'splunk'
    }
  }

  $forwarder_src_pkg = "splunkforwarder-${package_suffix}"
  $server_src_pkg    = "splunk-${package_suffix}"

  $server_pkg_src    = "${src_root}/${server_src_subdir}/${server_src_pkg}"
  $forwarder_pkg_src = "${src_root}/${forwarder_src_subdir}/${forwarder_src_pkg}"

}
