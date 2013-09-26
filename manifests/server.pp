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
    before => Package[$package_name],
  }

  package { $package_name:
    ensure   => installed,
    provider => $splunk::params::pkg_provider,
    source   => "${staging::path}/${staging_subdir}/${staged_package}",
    before   => Service[$virtual_service],
  }

  splunk_input { 'default_host':
    section => 'default',
    setting => 'host',
    value   => $::clientcert,
    tag     => 'splunk_server',
  }

  case $::kernel {
    default: { } # no special configuration needed
    'Linux': { include splunk::platform::linux }
  }

  # Realize and setup chain dependencies for resources shared between server
  # and forwarder profiles
  include splunk::virtual

  Package       <| title == $package_name    |> ->
  Exec          <| tag   == 'splunk_server'  |> ->
  Service       <| title == $virtual_service |>

  Package       <| title == $package_name    |> ->
  Splunk_input  <| tag   == 'splunk_server'  |> ~>
  Service       <| title == $virtual_service |>

  Package       <| title == $package_name    |> ->
  Splunk_output <| tag   == 'splunk_server'  |> ~>
  Service       <| title == $virtual_service |>

}
