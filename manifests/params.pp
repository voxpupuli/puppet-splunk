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
#   the puppet/archive module supports. This includes both puppet:// and
#   http://.  The expected directory structure is:
#
#
#     $root_url/
#     └── products/
#         ├── universalforwarder/
#         │   └── releases/
#         |       └── $version/
#         |           └── $platform/
#         |               └── splunkforwarder-${version}-${build}-${additl}
#         └── splunk/
#             └── releases/
#                 └── $version/
#                     └── $platform/
#                         └── splunk-${version}-${build}-${additl}
#
#
#   A semi-populated example src_root then contain:
#
#     $root_url/
#     └── products/
#         ├── universalforwarder/
#         │   └── releases/
#         |       └── 7.0.0/
#         |           ├── linux/
#         |           |   ├── splunkforwarder-7.0.0-c8a78efdd40f-linux-2.6-amd64.deb
#         |           |   ├── splunkforwarder-7.0.0-c8a78efdd40f-linux-2.6-intel.deb
#         |           |   └── splunkforwarder-7.0.0-c8a78efdd40f-linux-2.6-x86_64.rpm
#         |           ├── solaris/
#         |           └── windows/
#         |               └── splunkforwarder-7.0.0-c8a78efdd40f-x64-release.msi
#         └── splunk/
#             └── releases/
#                 └── 7.0.0/
#                     └── linux/
#                         ├── splunk-7.0.0-c8a78efdd40f-linux-2.6-amd64.deb
#                         ├── splunk-7.0.0-c8a78efdd40f-linux-2.6-intel.deb
#                         └── splunk-7.0.0-c8a78efdd40f-linux-2.6-x86_64.rpm
#
#
# Actions:
#
#   Declares parameters to be consumed by other classes in the splunk module.
#
# Requires: nothing
#
class splunk::params (
  $version              = '7.0.0',
  $build                = 'c8a78efdd40f',
  $src_root             = 'https://download.splunk.com',
  $splunkd_port         = '8089',
  $logging_port         = '9997',
  $server               = 'splunk',
  $forwarder_installdir = undef,
  $server_installdir    = undef,
) {

  # Based on the small number of inputs above, we can construct sane defaults
  # for pretty much everything else.

  # Settings common to everything
  $staging_subdir = 'splunk'
  #password setting settings - default changeme
  $secret           = 'hhy9DOGqli4.aZWCuGvz8stcqT2/OSJUZuyWHKc4wnJtQ6IZu2bfjeElgYmGHN9RWIT3zs5hRJcX1wGerpMNObWhFue78jZMALs3c3Mzc6CzM98/yGYdfcvWMo1HRdKn82LVeBJI5dNznlZWfzg6xdywWbeUVQZcOZtODi10hdxSJ4I3wmCv0nmkSWMVOEKHxti6QLgjfuj/MOoh8.2pM0/CqF5u6ORAzqFZ8Qf3c27uVEahy7ShxSv2K4K41z'
  $password_content = ':admin:$6$pIE/xAyP9mvBaewv$4GYFxC0SqonT6/x8qGcZXVCRLUVKODj9drDjdu/JJQ/Iw0Gg.aTkFzCjNAbaK4zcCHbphFz1g1HK18Z2bI92M0::Administrator:admin:changeme@example.com::'


  if $::osfamily == 'Windows' {
    $forwarder_dir = pick($forwarder_installdir, 'C:\\Program Files\\SplunkUniversalForwarder')
    $server_dir    = pick($server_installdir, 'C:/Program Files/Splunk')
    $splunk_user   = 'Administrator'
  } else {
    $forwarder_dir = pick($forwarder_installdir, '/opt/splunkforwarder')
    $server_dir    = pick($server_installdir, '/opt/splunk')
    $splunk_user   = 'root'
  }

  # Settings common to a kernel
  case $::kernel {
    'Linux': {
      $path_delimiter       = '/'
      $forwarder_src_subdir = 'linux'
      $forwarder_service    = [ 'splunk' ]
      $password_config_file = "${forwarder_dir}/etc/passwd"
      $secret_file          = "${forwarder_dir}/etc/splunk.secret"
      $forwarder_confdir    = "${forwarder_dir}/etc"
      $server_src_subdir    = 'linux'
      $server_service       = [ 'splunk', 'splunkd', 'splunkweb' ]
      $server_confdir       = "${server_dir}/etc"
      $forwarder_install_options = undef
    }
    'SunOS': {
      $path_delimiter       = '/'
      $forwarder_src_subdir = 'solaris'
      $forwarder_service    = [ 'splunk' ]
      $password_config_file = "${forwarder_dir}/etc/passwd"
      $secret_file          = "${forwarder_dir}/etc/splunk.secret"
      $forwarder_confdir    = "${forwarder_dir}/etc"
      $server_src_subdir    = 'solaris'
      $server_service       = [ 'splunk', 'splunkd', 'splunkweb' ]
      $server_confdir       = "${server_dir}/etc"
      $forwarder_install_options = undef
    }
    'Windows': {
      $path_delimiter       = '\\'
      $forwarder_src_subdir = 'windows'
      $password_config_file = 'C:/Program Files/SplunkUniversalForwarder/etc/passwd'
      $secret_file          =  'C:/Program Files/SplunkUniversalForwarder/etc/splunk.secret'
      $forwarder_service    = [ 'SplunkForwarder' ] # UNKNOWN
      $forwarder_confdir    = "${forwarder_dir}/etc"
      $server_src_subdir    = 'windows'
      $server_service       = [ 'Splunkd', 'SplunkWeb' ] # UNKNOWN
      $server_confdir       = "${server_dir}/etc"
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
        { 'INSTALLDIR' => $forwarder_dir },
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
    default: { fail("splunk module does not support kernel ${::kernel}") }
  }
  # default splunk agent settings in a hash so that the cya be easily parsed to other classes

  $forwarder_output = {
    'tcpout_defaultgroup'          => {
      section                      => 'default',
      setting                      => 'defaultGroup',
      value                        => "${server}_${logging_port}",
      tag                          => 'splunk_forwarder',
    },
    'defaultgroup_server' => {
      section             => "tcpout:${server}_${logging_port}",
      setting             => 'server',
      value               => "${server}:${logging_port}",
      tag                 => 'splunk_forwarder',
    },
  }
  $forwarder_input = {
    'default_host' => {
      section      => 'default',
      setting      => 'host',
      value        => $::clientcert,
      tag          => 'splunk_forwarder',
    },
  }
  # Settings common to an OS family
  case $::osfamily {
    'RedHat':  { $pkg_provider = 'rpm'  }
    'Debian':  { $pkg_provider = 'dpkg' }
    'Solaris': { $pkg_provider = 'sun'  }
    default:   { $pkg_provider = undef  } # Don't define a $pkg_provider
  }

  # Settings specific to an architecture as well as an OS family
  case "${::osfamily} ${::architecture}" {
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
    default: { fail("unsupported osfamily/arch ${::osfamily}/${::architecture}") }
  }

  $forwarder_src_pkg = "splunkforwarder-${package_suffix}"
  $server_src_pkg    = "splunk-${package_suffix}"

  $server_pkg_ensure = 'installed'
  $server_pkg_src    = "${src_root}/products/splunk/releases/${version}/${server_src_subdir}/${server_src_pkg}"
  $forwarder_pkg_src = "${src_root}/products/universalforwarder/releases/${version}/${forwarder_src_subdir}/${forwarder_src_pkg}"
  $create_password   = true

  $forwarder_pkg_ensure = 'installed'

  # A meta resource so providers know where splunk is installed:
  splunk_config { 'splunk':
    forwarder_installdir => $forwarder_dir,
    forwarder_confdir    => $forwarder_confdir,
    server_installdir    => $server_dir,
    server_confdir       => $server_confdir,
  }
}
