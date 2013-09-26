class splunk::forwarder (
  $ensure            = present,
  $server            = 'splunk',
  $logging_port      = $splunk::params::logging_port,
  $package_source    = $splunk::params::forwarder_pkg_src,
  $package_name      = $splunk::params::forwarder_pkg_name,
) inherits splunk::params {
  include splunk
  include staging

  $virtual_service = $splunk::params::forwarder_virtual_service
  $staged_package  = staging_parse($package_source)
  $staging_subdir  = 'splunk'

  staging::file { $staged_package:
    source => $package_source,
    subdir => $staging_subdir,
    before => Package[$package_name],
  }

  package { $package_name:
    ensure   => installed,
    provider => $pkg_provider,
    source   => "${staging::path}/${staging_subdir}/${staged_package}",
    before   => Service[$virtual_service],
  }

  # Realize and setup chain dependencies for resources shared between server
  # and forwarder profiles
  include splunk::virtual
  Service      <| title == $virtual_service   |> <- Package[$package_name]
  Splunk_input <| tag   == 'splunk_forwarder' |> ~> Service[$virtual_service]

  # Declare outputs specific to the forwarder profile
  splunk_output { 'tcpout_defaultgroup':
    section => 'default',
    setting => 'defaultGroup',
    value   => "${server}_${logging_port}",
  }
  splunk_output { 'defaultgroup_server':
    section => "tcpout:${server}_${logging_port}",
    setting => 'server',
    value   => "${server}:${logging_port}",
  }

  case $::kernel {
    default: { } # no special configuration needed
    'Linux': { include splunk::platform::linux }
  }

}
