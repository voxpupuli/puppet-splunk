# @summary
#   Accepts settings, and provides default values for module parameters.
#   Parameters class only: contributes no resources to the graph.
#
# @param version
#   The version of Splunk to install. This will be in the form x.y.z; e.g.
#   "4.3.2".
#
# @param build
#   Splunk packages are typically named based on the platform, architecture,
#   version, and build. Puppet can determine the platform information
#   automatically but a build number must be supplied in order to correctly
#   construct the path to the packages. A build number will be six digits;
#   e.g. "123586".
#
# @param splunkd_port
#   The splunkd port.
#
# @param logging_port
#   The port on which to send logs, and listen for logs.
#
# @param server
#   Optional fqdn or IP of the Splunk Enterprise server.  Used for setting up
#   the default TCP output and input.
#
# @param splunk_user
#   The user that splunk runs as.
#
# @param src_root
#   The root URL at which to find the splunk packages. The sane-default logic
#   assumes that the packages are located under this URL in the same way that
#   they are placed on download.splunk.com. The URL can be any protocol that
#   the puppet/archive module supports. This includes both puppet:// and
#   http://.
#
#   The expected directory structure is:
#
#   ```
#   $root_url/
#   └── products/
#       ├── universalforwarder/
#       │   └── releases/
#       |       └── $version/
#       |           └── $platform/
#       |               └── splunkforwarder-${version}-${build}-${additl}
#       └── splunk/
#           └── releases/
#               └── $version/
#                   └── $platform/
#                       └── splunk-${version}-${build}-${additl}
#   ```
#
#   A semi-populated example of `src_root` contains:
#
#   ```
#   $root_url/
#   └── products/
#       ├── universalforwarder/
#       │   └── releases/
#       |       └── 7.2.4.2/
#       |           ├── linux/
#       |           |   ├── splunkforwarder-7.2.4.2-fb30470262e3-linux-2.6-amd64.deb
#       |           |   ├── splunkforwarder-7.2.4.2-fb30470262e3-linux-2.6-intel.deb
#       |           |   └── splunkforwarder-7.2.4.2-fb30470262e3-linux-2.6-x86_64.rpm
#       |           ├── solaris/
#       |           └── windows/
#       |               └── splunkforwarder-7.2.4.2-fb30470262e3-x64-release.msi
#       └── splunk/
#           └── releases/
#               └── 7.2.4.2/
#                   └── linux/
#                       ├── splunk-7.2.4.2-fb30470262e3-linux-2.6-amd64.deb
#                       ├── splunk-7.2.4.2-fb30470262e3-linux-2.6-intel.deb
#                       └── splunk-7.2.4.2-fb30470262e3-linux-2.6-x86_64.rpm
#   ```
#
# @param boot_start
#   Enable Splunk to start at boot, create a system service file.
#
#   WARNING: Toggling `boot_start` from `false` to `true` will cause a restart of
#   Splunk Enterprise and Forwarder services.
#
# @param forwarder_installdir
#   Optional directory in which to install and manage Splunk Forwarder
#
# @param enterprise_installdir
#   Optional directory in which to install and manage Splunk Enterprise
#
# @param default_host
#   The host property in inputs.conf. Defaults to the server's hostname.
#
# @param manage_net_tools
#   From Splunk 7.2.2+ the package `net-tools` is required to be installed on the system.
#   By default this module manages the resource Package[net-tools], if this resource is
#   already declared on your code base, you can disable this flag.
#
# @param allow_insecure
#   Disable certificate verification when connecting to SSL hosts to download packages.
#
class splunk::params (
  String[1] $version                         = '9.2.0.1',
  String[1] $build                           = 'd8ae995bf219',
  String[1] $src_root                        = 'https://download.splunk.com',
  Stdlib::Port $splunkd_port                 = 8089,
  Stdlib::Port $logging_port                 = 9997,
  String[1] $server                          = 'splunk',
  Optional[String[1]] $forwarder_installdir  = undef,
  Optional[String[1]] $enterprise_installdir = undef,
  Boolean $boot_start                        = true,
  String[1] $splunk_user                     = $facts['os']['family'] ? {
    'windows' => 'Administrator',
    default => versioncmp($version, '8.0.0') ? { -1 => 'root', default => 'splunk' },
  },
  String[1] $default_host                    = $facts['clientcert'],
  Boolean $manage_net_tools                  = true,
  Boolean $allow_insecure                    = false,
) {
  # Based on the small number of inputs above, we can construct sane defaults
  # for pretty much everything else.

  # To generate password_content, change the password on enterprise or
  # forwarder, then distribute the contents of the splunk.secret and passwd
  # files accross all nodes.
  # By default the parameters provided are for admin/changeme password.
  $manage_password       = false
  $seed_password         = false
  $reset_seeded_password = false
  $secret                = 'hhy9DOGqli4.aZWCuGvz8stcqT2/OSJUZuyWHKc4wnJtQ6IZu2bfjeElgYmGHN9RWIT3zs5hRJcX1wGerpMNObWhFue78jZMALs3c3Mzc6CzM98/yGYdfcvWMo1HRdKn82LVeBJI5dNznlZWfzg6xdywWbeUVQZcOZtODi10hdxSJ4I3wmCv0nmkSWMVOEKHxti6QLgjfuj/MOoh8.2pM0/CqF5u6ORAzqFZ8Qf3c27uVEahy7ShxSv2K4K41z'
  $seed_user             = 'admin'
  $password_hash         = '$6$pIE/xAyP9mvBaewv$4GYFxC0SqonT6/x8qGcZXVCRLUVKODj9drDjdu/JJQ/Iw0Gg.aTkFzCjNAbaK4zcCHbphFz1g1HK18Z2bI92M0'
  $password_content      = ":admin:${password_hash}::Administrator:admin:changeme@example.com::"

  if $facts['os']['family'] == 'windows' {
    $staging_dir        = "${facts['archive_windir']}\\splunk"
    $enterprise_homedir = pick($enterprise_installdir, 'C:\\Program Files\\Splunk')
    $forwarder_homedir  = pick($forwarder_installdir, 'C:\\Program Files\\SplunkUniversalForwarder')
  } else {
    $staging_dir        = '/opt/staging/splunk'
    $enterprise_homedir = pick($enterprise_installdir, '/opt/splunk')
    $forwarder_homedir  = pick($forwarder_installdir, '/opt/splunkforwarder')
  }

  $additional_windows_forwarder_install_options = if $facts['os']['family'] == 'windows' and versioncmp($version, '9.1.3') == 0 {
    # See https://docs.splunk.com/Documentation/Forwarder/9.1.3/Forwarder/KnownIssues
    ['USE_LOCAL_SYSTEM=1']
  } else {
    []
  }

  # Settings common to a kernel
  case $facts['kernel'] {
    'Linux': {
      $path_delimiter                  = '/'
      $forwarder_src_subdir            = 'linux'
      $forwarder_seed_config_file      = "${forwarder_homedir}/etc/system/local/user-seed.conf"
      $enterprise_seed_config_file     = "${enterprise_homedir}/etc/system/local/user-seed.conf"
      $forwarder_password_config_file  = "${forwarder_homedir}/etc/passwd"
      $enterprise_password_config_file = "${enterprise_homedir}/etc/passwd"
      $forwarder_secret_file           = "${forwarder_homedir}/etc/auth/splunk.secret"
      $enterprise_secret_file          = "${enterprise_homedir}/etc/auth/splunk.secret"
      $forwarder_confdir               = "${forwarder_homedir}/etc"
      $enterprise_src_subdir           = 'linux'
      $enterprise_confdir              = "${enterprise_homedir}/etc"
      $forwarder_install_options       = []
      $enterprise_install_options      = []
      $forwarder_service_enable        = 'true'
      # Systemd not supported until Splunk 7.2.2
      if $facts['service_provider'] == 'systemd' and versioncmp($version, '7.2.2') >= 0 {
        $enterprise_service      = 'Splunkd'
        $forwarder_service       = 'SplunkForwarder'
        $enterprise_service_file = '/etc/systemd/system/Splunkd.service'
        $forwarder_service_file  = '/etc/systemd/system/SplunkForwarder.service'
        $boot_start_args         = '-systemd-managed 1'
        $supports_systemd        = true
      }
      else {
        $enterprise_service      = 'splunk'
        $forwarder_service       = 'splunk'
        $enterprise_service_file = '/etc/init.d/splunk'
        $forwarder_service_file  = '/etc/init.d/splunk'
        $boot_start_args         = ''
        $supports_systemd        = false
      }
    }
    'SunOS': {
      $path_delimiter                  = '/'
      $forwarder_src_subdir            = 'solaris'
      $forwarder_seed_config_file      = "${forwarder_homedir}/etc/system/local/user-seed.conf"
      $enterprise_seed_config_file     = "${enterprise_homedir}/etc/system/local/user-seed.conf"
      $forwarder_password_config_file  = "${forwarder_homedir}/etc/passwd"
      $enterprise_password_config_file = "${enterprise_homedir}/etc/passwd"
      $forwarder_secret_file           = "${forwarder_homedir}/etc/auth/splunk.secret"
      $enterprise_secret_file          = "${enterprise_homedir}/etc/auth/splunk.secret"
      $forwarder_confdir               = "${forwarder_homedir}/etc"
      $enterprise_src_subdir           = 'solaris'
      $enterprise_confdir              = "${enterprise_homedir}/etc"
      $forwarder_install_options       = []
      $enterprise_install_options      = []
      $forwarder_service_enable        = 'true'
      # Systemd not supported until Splunk 7.2.2
      if $facts['service_provider'] == 'systemd' and versioncmp($version, '7.2.2') >= 0 {
        $enterprise_service      = 'Splunkd'
        $forwarder_service       = 'SplunkForwarder'
        $enterprise_service_file = '/etc/systemd/system/multi-user.target.wants/Splunkd.service'
        $forwarder_service_file  = '/etc/systemd/system/multi-user.target.wants/SplunkForwarder.service'
        $boot_start_args         = '-systemd-managed 1'
        $supports_systemd        = true
      }
      else {
        $enterprise_service      = 'splunk'
        $forwarder_service       = 'splunk'
        $enterprise_service_file = '/etc/init.d/splunk'
        $forwarder_service_file  = '/etc/init.d/splunk'
        $boot_start_args         = ''
        $supports_systemd        = false
      }
    }
    'FreeBSD': {
      $path_delimiter                  = '/'
      $forwarder_src_subdir            = 'freebsd'
      $forwarder_seed_config_file      = "${forwarder_homedir}/etc/system/local/user-seed.conf"
      $enterprise_seed_config_file     = "${enterprise_homedir}/etc/system/local/user-seed.conf"
      $forwarder_password_config_file  = "${forwarder_homedir}/etc/passwd"
      $enterprise_password_config_file = "${enterprise_homedir}/etc/passwd"
      $forwarder_secret_file           = "${forwarder_homedir}/etc/auth/splunk.secret"
      $enterprise_secret_file          = "${enterprise_homedir}/etc/auth/splunk.secret"
      $forwarder_confdir               = "${forwarder_homedir}/etc"
      $enterprise_src_subdir           = 'freebsd'
      $enterprise_confdir              = "${enterprise_homedir}/etc"
      $forwarder_install_options       = ['-f'] # ignore the wrong os major version specified in the package
      $enterprise_install_options      = []
      $enterprise_service              = 'splunk'
      $forwarder_service               = 'splunk'
      $forwarder_service_enable        = 'true'
      $enterprise_service_file         = '/etc/rc.d/splunk'
      $forwarder_service_file          = '/etc/rc.d/splunk'
      $boot_start_args                 = ''
      $supports_systemd                = false
    }
    'windows': {
      $path_delimiter                  = '\\'
      $forwarder_src_subdir            = 'windows'
      $forwarder_seed_config_file      = "${forwarder_homedir}\\etc\\system\\local\\user-seed.conf"
      $enterprise_seed_config_file     = "${enterprise_homedir}\\etc\\system\\local\\user-seed.conf"
      $forwarder_password_config_file  = "${forwarder_homedir}\\etc\\passwd"
      $enterprise_password_config_file = "${enterprise_homedir}\\etc\\passwd"
      $forwarder_secret_file           = "${forwarder_homedir}\\etc\\auth\\splunk.secret"
      $enterprise_secret_file          = "${enterprise_homedir}\\etc\\auth\\splunk.secret"
      $forwarder_service               = 'SplunkForwarder'
      $forwarder_service_enable        = 'delayed'
      $forwarder_service_file          = "${forwarder_homedir}\\dummy" # Not used in Windows, but attribute must be defined with a valid path
      $forwarder_confdir               = "${forwarder_homedir}\\etc"
      $enterprise_src_subdir           = 'windows'
      $enterprise_service              = 'splunkd' # Not validated
      $enterprise_service_file          = "${enterprise_homedir}\\dummy" # Not used in Windows, but attribute must be defined with a valid path
      $enterprise_confdir              = "${enterprise_homedir}\\etc"
      $forwarder_install_options       = [
        { 'INSTALLDIR' => $forwarder_homedir },
        'AGREETOLICENSE=Yes',
        'LAUNCHSPLUNK=0',
        'SERVICESTARTTYPE=auto',
        'WINEVENTLOG_APP_ENABLE=1',
        'WINEVENTLOG_SEC_ENABLE=1',
        'WINEVENTLOG_SYS_ENABLE=1',
        'WINEVENTLOG_FWD_ENABLE=1',
        'WINEVENTLOG_SET_ENABLE=1',
        'ENABLEADMON=1',
      ] + $additional_windows_forwarder_install_options
      $enterprise_install_options     = [
        { 'INSTALLDIR' => $enterprise_homedir },
        { 'SPLUNKD_PORT' => String($splunkd_port) },
        'AGREETOLICENSE=Yes',
        'LAUNCHSPLUNK=0',
      ]
    }
    default: { fail("splunk module does not support kernel ${facts['kernel']}") }
  }
  # default splunk agent settings in a hash so that the cya be easily parsed to other classes

  $forwarder_output = {
    'tcpout_defaultgroup' => {
      section             => 'default',
      setting             => 'defaultGroup',
      value               => "${server}_${logging_port}",
      tag                 => 'splunk_forwarder',
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
      value        => $default_host,
      tag          => 'splunk_forwarder',
    },
  }
  # Settings common to an OS family
  case $facts['os']['family'] {
    'RedHat':  { $package_provider = 'rpm' }
    'Debian':  { $package_provider = 'dpkg' }
    'Solaris': { $package_provider = 'sun' }
    'Suse':    { $package_provider = 'rpm' }
    'FreeBSD': { $package_provider = 'pkgng' }
    'windows': { $package_provider = 'windows' }
    default:   { $package_provider = undef } # Don't define a $package_provider
  }

  # Download URLs changed starting from 9.4.0 for debs.
  # Splunk only includes "-linux-".
  if versioncmp($version, '9.4.0') >= 0 {
    $deb_prefix = 'linux'
  } else {
    $deb_prefix = 'linux-2.6'
  }
  # Download URLs changed starting from 8.2.11 and 9.0.5 for RPMs.
  # Splunk no longer includes "-linux-2.6-".
  $linux_prefix = (versioncmp($version, '9.0.5') >= 0 or (versioncmp($version, '8.2.11') >= 0 and versioncmp($version, '9.0.0') == -1)) ? {
    true  => '.',
    false => '-linux-2.6-',
  }

  # Settings specific to an architecture as well as an OS family
  case "${facts['os']['family']} ${facts['os']['architecture']}" {
    'RedHat i386': {
      $package_suffix          = "${version}-${build}.i386.rpm"
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    'RedHat x86_64': {
      $package_suffix          = "${version}-${build}${linux_prefix}x86_64.rpm"
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    'RedHat ppc64le': {
      $package_suffix          = "${version}-${build}${linux_prefix}ppc64le.rpm"
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    'RedHat aarch64': {
      $package_suffix          = "${version}-${build}${linux_prefix}aarch64.rpm"
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    'Debian i386': {
      $package_suffix          = "${version}-${build}-linux-2.6-intel.deb"
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    'Debian amd64': {
      $package_suffix          = "${version}-${build}-${deb_prefix}-amd64.deb"
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    'Debian aarch64': {
      $package_suffix = versioncmp($version, '9.4.0') >= 0 ? {
        true  => "${version}-${build}-linux-arm64.deb",
        false => "${version}-${build}-Linux-armv8.deb"
      }
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    /^(W|w)indows (x86|i386)$/: {
      $package_suffix          = "${version}-${build}-x86-release.msi"
      $forwarder_package_name  = 'UniversalForwarder'
      $enterprise_package_name = 'Splunk Enterprise'
    }
    /^(W|w)indows (x64|x86_64)$/: {
      $package_suffix          = "${version}-${build}-x64-release.msi"
      $forwarder_package_name  = 'UniversalForwarder'
      $enterprise_package_name = 'Splunk Enterprise'
    }
    'Solaris i86pc': {
      $package_suffix          = "${version}-${build}-solaris-10-intel.pkg"
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    'Solaris sun4v': {
      $package_suffix          = "${version}-${build}-solaris-8-sparc.pkg"
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    'Suse x86_64': {
      $package_suffix          = "${version}-${build}${linux_prefix}x86_64.rpm"
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    'FreeBSD amd64': {
      $package_suffix          = "${version}-${build}-freebsd-11.1-amd64.txz"
      $forwarder_package_name  = 'splunkforwarder'
      $enterprise_package_name = 'splunk'
    }
    default: { fail("unsupported osfamily/arch ${facts['os']['family']}/${facts['os']['architecture']}") }
  }

  $forwarder_src_package  = "splunkforwarder-${package_suffix}"
  $enterprise_src_package = "splunk-${package_suffix}"

  $enterprise_package_ensure = 'installed'
  $enterprise_package_src    = "${src_root}/products/splunk/releases/${version}/${enterprise_src_subdir}/${enterprise_src_package}"
  $forwarder_package_ensure = 'installed'
  $forwarder_package_src = "${src_root}/products/universalforwarder/releases/${version}/${forwarder_src_subdir}/${forwarder_src_package}"

  # A meta resource so providers know where splunk is installed:
  splunk_config { 'splunk':
    forwarder_installdir => $forwarder_homedir,
    forwarder_confdir    => $forwarder_confdir,
    server_installdir    => $enterprise_homedir,
    server_confdir       => $enterprise_confdir,
  }
}
