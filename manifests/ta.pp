#
# Defined type: splunk::ta
#
# This define sets up a TA (Technology Addon) for Splunk.  It (optionally)
# installed a package, and configures input forwarders in 
# $SPLUNK_HOME/etc/apps/<app name>/local/inputs.conf
#
# Examples
#
# splunk::ta { 'search':
#   install_package => false,
# }
#
# splunk::ta::input { 'monitor:///var/log/messages':
#   attributes => {
#     'index' => 'server_t',
#   },
# }
#
# Alternatively you can feed inputs directly into splunk::ta using the
# inputs parameter (useful if you are configuring from Hiera)
#
#
# splunk::ta { 'search':
#   install_package => false,
#   inputs          => {
#     'monitor:///var/log/messages' => {
#       'attributes' => {
#         'index' => 'server_t',
#       }
#     }
#   }
# }
#
define splunk::ta (
  $splunk_home = '/opt/splunkforwarder',
  $install_package = true,
  $package_name = undef,
  $inputs = {},
) {


  if ( $install_package ) {
    validate_string($package_name)
    package { $package_name:
      ensure => installed,
      before => File["${splunk_home}/etc/apps/${name}/local"],
    }
  }

  file { "${splunk_home}/etc/apps/${name}/local":
    ensure => directory,
  }

  concat { "splunk::ta::inputs_${name}":
    path    => "${splunk_home}/etc/apps/${name}/local/inputs.conf",
    require => File["${splunk_home}/etc/apps/${name}/local"]
  }

   ## Stop concat::fragment from failing if no inputs are defined.
   concat::fragment { "splunk::ta::inputs_${name}::blank":
     content => "# Managed by Puppet\n",
     target  => "splunk::ta::inputs_${name}",
     order   => '0',
   }

   create_resources('splunk::ta::input', $inputs, {"ta" =>  $name })

}

