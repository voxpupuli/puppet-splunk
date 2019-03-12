# Class: splunk
#
# This class deploys the Splunk Universal Forwarder on Linux, Windows, Solaris
# platforms.
#
# Parameters:
#
# [*server*]
#   The address of a server to send logs to.
#
# [*manage_package_source*]
#   By default, this class will handle downloading the Splunk module you need
#   but you can set this to false if you do not want that behaviour
#
# [*package_source*]
#   The source URL for the splunk installation media (typically an RPM, MSI,
#   etc). If a $src_root parameter is set in splunk::params, this will be
#   automatically supplied. Otherwise it is required. The URL can be of any
#   protocol supported by the nanliu/staging module. On Windows, this can
#   be a UNC path to the MSI.
#
# [*package_name*]
#   The name of the package(s) as they will exist or be detected on the host.
#
# [*logging_port*]
#   The port to send splunktcp logs to.
#
# [*splunkd_port*]
#   The splunkd port. Used as a default for both splunk and splunk::forwarder.
#
# [*install_options*]
#   The splunkd forwarder installation options. Only applicable for Windows.
#
# [*splunkd_listen*]
#   The address on which splunkd should listen. Defaults to localhost only.
#
# [*purge_inputs*]
#   If set to true, will remove any inputs.conf configuration not supplied by
#   Puppet from the target system. Defaults to false.
#
# [*purge_outputs*]
#   If set to true, will remove any outputs.conf configuration not supplied by
#   Puppet from the target system. Defaults to false.
#
# [*forwarder_output*]
#   Hash of output configs.  If undefined will not populate the outputs.conf file.
#
# [*forwarder_input*]
#   Hash of input configs.  If undefined will not populate the inputs.conf file.
#
# Actions:
#
#   Declares parameters to be consumed by other classes in the splunk module.
#
# Requires: nothing
#
class splunk::forwarder (
  String $server                        = $splunk::params::server,
  Boolean $manage_package_source        = true,
  Optional[String] $package_source      = undef,
  String $package_name                  = $splunk::params::forwarder_pkg_name,
  String $package_ensure                = $splunk::params::forwarder_pkg_ensure,
  Stdlib::Port $logging_port            = $splunk::params::logging_port,
  Stdlib::Port $splunkd_port            = $splunk::params::splunkd_port,
  Optional[Array] $install_options      = $splunk::params::forwarder_install_options,
  String $splunk_user                   = $splunk::params::splunk_user,
  Stdlib::Host $splunkd_listen          = '127.0.0.1',
  Boolean $purge_deploymentclient       = false,
  Boolean $purge_inputs                 = false,
  Boolean $purge_outputs                = false,
  Boolean $purge_props                  = false,
  Boolean $purge_transforms             = false,
  Boolean $purge_web                    = false,
  Optional[String] $pkg_provider        = $splunk::params::pkg_provider,
  String $forwarder_confdir             = $splunk::params::forwarder_confdir,
  Hash $forwarder_output                = $splunk::params::forwarder_output,
  Hash $forwarder_input                 = $splunk::params::forwarder_input,
  Boolean $create_password              = $splunk::params::create_password,
  Hash $addons                          = {},
) inherits splunk::params {

  $virtual_service = $splunk::params::forwarder_service
  $staging_subdir  = $splunk::params::staging_subdir

  $path_delimiter  = $splunk::params::path_delimiter

  $_package_source = $manage_package_source ? {
    true  => $splunk::params::forwarder_pkg_src,
    false => $package_source,
  }

  #no need for staging the source if we have yum or apt
  if $pkg_provider != undef and $pkg_provider != 'yum' and $pkg_provider != 'apt' and $pkg_provider != 'chocolatey' {
    include ::archive::staging

    $src_pkg_filename = basename($_package_source)
    $pkg_path_parts   = [$archive::path, $staging_subdir, $src_pkg_filename]
    $staged_package   = join($pkg_path_parts, $path_delimiter)

    archive { $staged_package:
      source  => $_package_source,
      extract => false,
      before  => Package[$package_name],
    }
  } else {
    $staged_package = undef
  }

  Package  {
    source          => $pkg_provider ? {
      'chocolatey' => undef,
      default      => $manage_package_source ? {
        true  => pick($staged_package, $_package_source),
        false => $_package_source,
      }
    },
  }

  package { $package_name:
    ensure          => $package_ensure,
    provider        => $pkg_provider,
    before          => Service[$virtual_service],
    install_options => $install_options,
    tag             => 'splunk_forwarder',
  }

  # Declare addons
  create_resources('splunk::addon', $addons)

  # Ensure that the service restarts upon changes to addons
  Package[$package_name] -> Splunk::Addon <||> ~> Service[$virtual_service]

  # Declare inputs and outputs specific to the forwarder profile
  $tag_resources = { tag => 'splunk_forwarder' }
  if $forwarder_input {
    create_resources( 'splunkforwarder_input',$forwarder_input, $tag_resources)
  }
  if $forwarder_output {
    create_resources( 'splunkforwarder_output',$forwarder_output, $tag_resources)
  }
  # this is default
  splunkforwarder_web { 'forwarder_splunkd_port':
    section => 'settings',
    setting => 'mgmtHostPort',
    value   => "${splunkd_listen}:${splunkd_port}",
    tag     => 'splunk_forwarder',
  }

  # If the purge parameters have been set, remove all unmanaged entries from
  # the respective config files.

  Splunk_config['splunk'] {
    forwarder_confdir                => $forwarder_confdir,
    purge_forwarder_deploymentclient => $purge_deploymentclient,
    purge_forwarder_outputs          => $purge_outputs,
    purge_forwarder_inputs           => $purge_inputs,
    purge_forwarder_props            => $purge_props,
    purge_forwarder_transforms       => $purge_transforms,
    purge_forwarder_web              => $purge_web,
  }

  # This is a module that supports multiple platforms. For some platforms
  # there is non-generic configuration that needs to be declared in addition
  # to the agnostic resources declared here.
  case $::kernel {
    'Linux': {
      class { '::splunk::platform::posix':
        splunk_user  => $splunk_user,
      }
    }
    'SunOS': { include ::splunk::platform::solaris }
    default: { } # no special configuration needed
  }

  # Realize resources shared between server and forwarder profiles, and set up
  # dependency chains.
  include ::splunk::virtual

  realize Service[$virtual_service]

  Package[$package_name]
  -> File <| tag   == 'splunk_forwarder' |>
  -> Exec <| tag   == 'splunk_forwarder' |>
  -> Service[$virtual_service]

  Package[$package_name] -> Splunkforwarder_deploymentclient<||> ~> Service[$virtual_service]
  Package[$package_name] -> Splunkforwarder_output<||>           ~> Service[$virtual_service]
  Package[$package_name] -> Splunkforwarder_input<||>            ~> Service[$virtual_service]
  Package[$package_name] -> Splunkforwarder_props<||>            ~> Service[$virtual_service]
  Package[$package_name] -> Splunkforwarder_transforms<||>       ~> Service[$virtual_service]
  Package[$package_name] -> Splunkforwarder_web<||>              ~> Service[$virtual_service]
  Package[$package_name] -> Splunkforwarder_limits<||>           ~> Service[$virtual_service]
  Package[$package_name] -> Splunkforwarder_server<||>           ~> Service[$virtual_service]

  File {
    owner => $splunk_user,
    group => $splunk_user,
    mode  => $facts['kernel'] ? {
      'windows' => undef,
      default   => '0600',
    },
    seluser => 'unconfined_u',
  }

  file { "${forwarder_confdir}/system/local/deploymentclient.conf":
    ensure => file,
    tag    => 'splunk_forwarder',
  }

  file { "${forwarder_confdir}/system/local/inputs.conf":
    ensure => file,
    tag    => 'splunk_forwarder',
  }

  file { "${forwarder_confdir}/system/local/outputs.conf":
    ensure => file,
    tag    => 'splunk_forwarder',
  }

  file { "${forwarder_confdir}/system/local/web.conf":
    ensure => file,
    tag    => 'splunk_forwarder',
  }

  file { "${forwarder_confdir}/system/local/limits.conf":
    ensure => file,
    tag    => 'splunk_forwarder',
  }

  file { "${forwarder_confdir}/system/local/server.conf":
    ensure => file,
    tag    => 'splunk_forwarder',
  }

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
