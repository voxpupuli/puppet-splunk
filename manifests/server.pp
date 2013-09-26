class splunk::server (
  $package_source = $splunk::params::server_pkg_src,
  $package_name   = $splunk::params::server_pkg_name,
  $logging_port   = $splunk::params::logging_port,
  $admin_port     = $splunk::params::admin_port,
  $splunkd_port   = $splunk::params::splunkd_port,
) inherits splunk::params {
  include splunk
  include staging

  $virtual_service = $splunk::params::server_virtual_service
  $staged_package  = staging_parse($package_source)
  $staging_subdir  = 'splunk'

  staging::file { $staged_package:
    source => $package_source,
    subdir => $staging_subdir,
    before => Package['splunk'],
  }

  package { $package_name:
    ensure   => installed,
    provider => $splunk::params::pkg_provider,
    source   => "${staging::path}/${staging_subdir}/${staged_package}",
    before   => Service[$virtual_service],
  }

  # Realize and setup chain dependencies for resources shared between server
  # and forwarder profiles
  include splunk::virtual
  Service      <| title == $virtual_service |> <- Package[$package_name]
  Splunk_input <| tag   == 'splunk_server'  |> ~> Service[$virtual_service]

  # Declare inputs specific to the server profile
  ## none at present

  case $::kernel {
    default: { } # no special configuration needed
    'Linux': { include splunk::platform::linux }
  }

}
