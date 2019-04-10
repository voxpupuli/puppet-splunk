#
# Defined type: splunk::addon
#
# This define sets up a TA (Technology Addon) for Splunk.  It (optionally)
# installed a package, and configures input forwarders in
# $SPLUNK_HOME/etc/apps/<app name>/local/inputs.conf
#
# Examples
#
# splunk::addon { 'search':
#   package_manage => false,
# }
#
# splunk::addon::input { 'monitor:///var/log/messages':
#   attributes => {
#     'index' => 'server_t',
#   },
# }
#
# Alternatively you can feed inputs directly into splunk::addon using the
# inputs parameter (useful if you are configuring from Hiera)
#
#
# splunk::addon { 'search':
#   package_manage => false,
#   inputs          => {
#     'monitor:///var/log/messages' => {
#       'attributes' => {
#         'index' => 'server_t',
#       }
#     }
#   }
# }
#
define splunk::addon (
  Optional[Stdlib::Absolutepath] $splunk_home = undef,
  Boolean $package_manage                     = true,
  Optional[String[1]] $splunkbase_source      = undef,
  Optional[String[1]] $package_name           = undef,
  Hash $inputs                                = {},
) {

  include splunk::params

  if defined(Class['splunk::forwarder']) {
    $mode = 'forwarder'
  } else {
    $mode = 'enterprise'
  }

  if $splunk_home {
    $_splunk_home = $splunk_home
  }
  else {
    case $mode {
      'forwarder':  { $_splunk_home = $splunk::params::forwarder_homedir }
      'enterprise': { $_splunk_home = $splunk::params::enterprise_homedir }
    }
  }

  if $package_manage {
    if $splunkbase_source {
      $archive_name = $splunkbase_source.split('/')[-1]
      archive { $name:
        path         => "${splunk::params::staging_dir}/${archive_name}",
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

  file { "${_splunk_home}/etc/apps/${name}/local": ensure => directory }

  unless $inputs.empty {
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
        }
      }
    }
  }
}

