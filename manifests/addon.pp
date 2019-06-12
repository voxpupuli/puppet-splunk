# @summary
#   Defined type for deploying Splunk Add-ons and Apps from either OS packages
#   or via splunkbase compatible archives
#
# @example Basic usage
#   splunk::addon { 'Splunk_TA_nix':
#     splunkbase_source => 'puppet:///modules/splunk_qd/addons/splunk-add-on-for-unix-and-linux_602.tgz',
#     inputs            => {
#       'monitor:///var/log'       => {
#        'whitelist' => '(\.log|log$|messages|secure|auth|mesg$|cron$|acpid$|\.out)',
#        'blacklist' => '(lastlog|anaconda\.syslog)',
#        'disabled'  => 'false'
#       },
#       'script://./bin/uptime.sh' =>  {
#         'disabled' => 'false',
#         'interval' => '86400',
#         'source' => 'Unix:Uptime',
#         'sourcetype' => 'Unix:Uptime'
#       }
#     }
#   }
#
# @see https://docs.splunk.com/Documentation/AddOns/released/Overview/AboutSplunkadd-ons
#
# @param splunk_home
#   Overrides the default Splunk installation target values from Class[splunk::params]
#
# @param package_manage
#   If a package should be installed as part of declaring a new instance of Splunk::Addon
#
# @param splunkbase_source
#   When set the add-on will be installed from a splunkbase compatible archive instead of OS packages
#
# @param package_name
#  The OS package to install if you are not installing via splunk compatible archive
#
# @param owner
#  The user that files are owned by when they are created as part of add-on installation
#
# @param inputs
#  A hash of inputs to be configured as part of add-on installation, alterntively you can also define splunk_input or splunkforwarder_input resouces seperately
#
define splunk::addon (
  Optional[Stdlib::Absolutepath] $splunk_home = undef,
  Boolean $package_manage                     = true,
  Optional[String[1]] $splunkbase_source      = undef,
  Optional[String[1]] $package_name           = undef,
  String[1] $owner                            = 'splunk',
  Hash $inputs                                = {},
) {

  if defined(Class['splunk::forwarder']) {
    $mode = 'forwarder'
  } elsif defined(Class['splunk::enterprise']) {
    $mode = 'enterprise'
  } else {
    fail('Instances of Splunk::Addon require the declaration of one of either Class[splunk::enterprise] or Class[splunk::forwarder]')
  }


  if $splunk_home {
    $_splunk_home = $splunk_home
  } else {
    case $mode {
      'forwarder':  { $_splunk_home = $splunk::params::forwarder_homedir }
      'enterprise': { $_splunk_home = $splunk::params::enterprise_homedir }
      default:      { fail('Instances of Splunk::Addon require the declaration of one of either Class[splunk::enterprise] or Class[splunk::forwarder]') }
    }
  }

  if $package_manage {
    if $splunkbase_source {
      $archive_name = $splunkbase_source.split('/')[-1]
      archive { $name:
        path         => "${splunk::params::staging_dir}/${archive_name}",
        user         => $owner,
        group        => $owner,
        source       => $splunkbase_source,
        extract      => true,
        extract_path => "${_splunk_home}/etc/apps",
        creates      => "${_splunk_home}/etc/apps/${name}",
        cleanup      => true,
        before       => File["${_splunk_home}/etc/apps/${name}/local"],
      }
    } else {
      package { $package_name:
        ensure => installed,
        before => File["${_splunk_home}/etc/apps/${name}/local"],
      }
    }
  }

  file { "${_splunk_home}/etc/apps/${name}/local":
    ensure => directory,
    owner  => $owner,
    group  => $owner,
  }

  $inputs.each |$section, $attributes| {
    $attributes.each |$setting, $value| {
      case $mode {
        'forwarder': {
          splunkforwarder_input { "${name}_${section}_${setting}":
            section => $section,
            setting => $setting,
            value   => $value,
            context => "apps/${name}/local",
            require => File["${_splunk_home}/etc/apps/${name}/local"],
          }
        }
        'enterprise': {
          splunk_input { "${name}_${section}_${setting}":
            section => $section,
            setting => $setting,
            value   => $value,
            context => "apps/${name}/local",
            require => File["${_splunk_home}/etc/apps/${name}/local"],
          }
        }
        default: { fail('Instances of Splunk::Addon require the declaration of one of either Class[splunk::enterprise] or Class[splunk::forwarder]') }
      }
    }
  }
}

