class splunk::forwarder (
  $ensure            = present,
  $server            = 'splunk',
  $logging_port      = $splunk::params::logging_port,
  $package_source    = $splunk::params::forwarder_pkg_src,
  $package_name      = $splunk::params::forwarder_pkg_name,
  $purge_inputs      = false,
  $purge_outputs     = false,
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

  # Declare inputs and outputs specific to the forwarder profile
  splunkforwarder_input { 'default_host':
    section => 'default',
    setting => 'host',
    value   => $::clientcert,
    tag     => 'splunk_forwarder',
  }
  splunkforwarder_output { 'tcpout_defaultgroup':
    section => 'default',
    setting => 'defaultGroup',
    value   => "${server}_${logging_port}",
    tag     => 'splunk_forwarder',
  }
  splunkforwarder_output { 'defaultgroup_server':
    section => "tcpout:${server}_${logging_port}",
    setting => 'server',
    value   => "${server}:${logging_port}",
    tag     => 'splunk_forwarder',
  }

  # If the purge parameters have been set, remove all unmanaged entries from
  # the inputs.conf and outputs.conf files, respectively.
  if $purge_inputs  {
    resources { 'splunkforwarder_input':  purge => true; }
  }
  if $purge_outputs {
    resources { 'splunkforwarder_output': purge => true; }
  }

  # This is a module that supports multiple platforms. For some platforms
  # there is non-generic configuration that needs to be declared in addition
  # to the agnostic resources declared here.
  case $::kernel {
    default: { } # no special configuration needed
    'Linux': { include splunk::platform::linux }
  }

  # Realize and setup chain dependencies for resources shared between server
  # and forwarder profiles
  include splunk::virtual

  Package               <| title == $package_name       |> ->
  Exec                  <| tag   == 'splunk_forwarder'  |> ->
  Service               <| title == $virtual_service |>

  Package               <| title == $package_name       |> ->
  Splunkforwarder_input <| tag   == 'splunk_forwarder'  |> ~>
  Service               <| title == $virtual_service    |>

  Package                <| title == $package_name      |> ->
  Splunkforwarder_output <| tag   == 'splunk_forwarder' |> ~>
  Service                <| title == $virtual_service   |>

}
