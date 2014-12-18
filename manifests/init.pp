# Class: splunk
#
# This class deploys Splunk on Linux, Windows, Solaris platforms.
#
# Parameters:
#
# [*package_source*]
#   The source URL for the splunk installation media (typically an RPM, MSI,
#   etc). If a $src_root parameter is set in splunk::params, this will be
#   automatically supplied. Otherwise it is required. The URL can be of any
#   protocol supported by the nanliu/staging module.
#
# [*package_name*]
#   The name of the package(s) as they will exist or be detected on the host.
#
# [*logging_port*]
#   The port to recieve splunktcp logs on.
#
# [*splunkd_port*]
#   The splunkd port. Used as a default for both splunk and splunk::forwarder.
#
# [*splunkd_listen*]
#   The address on which splunkd should listen. Defaults to localhost only.
#
# [*web_port*]
#   The port on which to serve the Splunk Web interface.
#
# [*purge_inputs*]
#   If set to true, will remove any inputs.conf configuration not supplied by
#   Puppet from the target system. Defaults to false.
#
# [*purge_outputs*]
#   If set to true, will remove any outputs.conf configuration not supplied by
#   Puppet from the target system. Defaults to false.
#
# Actions:
#
#   Declares parameters to be consumed by other classes in the splunk module.
#
# Requires: nothing
#
class splunk (
  $package_source = $splunk::params::server_pkg_src,
  $package_name   = $splunk::params::server_pkg_name,
  $logging_port   = $splunk::params::logging_port,
  $splunkd_port   = $splunk::params::splunkd_port,
  $splunkd_listen = '127.0.0.1',
  $web_port       = '8000',
  $purge_inputs   = false,
  $purge_outputs  = false,
) inherits splunk::params {
  include staging

  $virtual_service = $splunk::params::server_service
  $staged_package  = staging_parse($package_source)
  $staging_subdir  = $splunk::params::staging_subdir

  $path_delimiter  = $splunk::params::path_delimiter
  $pkg_path_parts  = [$staging::path, $staging_subdir, $staged_package]
  $pkg_source      = join($pkg_path_parts, $path_delimiter)

  staging::file { $staged_package:
    source => $package_source,
    subdir => $staging_subdir,
    before => Package[$package_name],
  }

  package { $package_name:
    ensure   => installed,
    provider => $splunk::params::pkg_provider,
    source   => $pkg_source,
    before   => Service[$virtual_service],
    tag      => 'splunk_server',
  }

  splunk_input { 'default_host':
    section => 'default',
    setting => 'host',
    value   => $::clientcert,
    tag     => 'splunk_server',
  }
  splunk_input { 'default_splunktcp':
    section => "splunktcp://:${logging_port}",
    setting => 'connection_host',
    value   => 'dns',
    tag     => 'splunk_server',
  }
  ini_setting { 'splunk_server_splunkd_port':
    path    => "${splunk::params::server_confdir}/web.conf",
    section => 'settings',
    setting => 'mgmtHostPort',
    value   => "${splunkd_listen}:${splunkd_port}",
    require => Package[$package_name],
    notify  => Service[$virtual_service],
  }
  ini_setting { 'splunk_server_web_port':
    path    => "${splunk::params::server_confdir}/web.conf",
    section => 'settings',
    setting => 'httpport',
    value   => $web_port,
    require => Package[$package_name],
    notify  => Service[$virtual_service],
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
    'Linux': { include splunk::platform::posix   }
    'SunOS': { include splunk::platform::solaris }
  }

  # Realize resources shared between server and forwarder profiles, and set up
  # dependency chains.
  include splunk::virtual

  # This realize() call is because the collectors don't seem to work well with
  # arrays. They'll set the dependencies but not realize all Service resources
  realize(Service[$virtual_service])

  Package       <| title == $package_name    |> ->
  Exec          <| tag   == 'splunk_server'  |> ->
  Service       <| title == $virtual_service |>

  Package       <| title == $package_name    |> ->
  Splunk_input  <| tag   == 'splunk_server'  |> ~>
  Service       <| title == $virtual_service |>

  Package       <| title == $package_name    |> ->
  Splunk_output <| tag   == 'splunk_server'  |> ~>
  Service       <| title == $virtual_service |>

  # Validate: if both Splunk and Splunk Universal Forwarder are installed on
  # the same system, then they must use different admin ports.
  if (defined(Class['splunk']) and defined(Class['splunk::forwarder'])) {
    $s_port = $splunk::splunkd_port
    $f_port = $splunk::forwarder::splunkd_port
    if $s_port == $f_port {
      fail(regsubst("Both splunk and splunk::forwarder are included, but both
        are configured to use the same splunkd port (${s_port}). Please either
        include only one of splunk, splunk::forwarder, or else configure them
        to use non-conflicting splunkd ports.", '\s\s+', ' ', 'G')
      )
    }
  }

}
