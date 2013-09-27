class splunk::forwarder (
  $server            = 'splunk',
  $package_source    = $splunk::params::forwarder_pkg_src,
  $package_name      = $splunk::params::forwarder_pkg_name,
  $logging_port      = $splunk::params::logging_port,
  $splunkd_listen    = '127.0.0.1',
  $splunkd_port      = '8089',
  $purge_inputs      = false,
  $purge_outputs     = false,
) inherits splunk::params {
  include splunk
  include staging

  $virtual_service = $splunk::params::forwarder_service
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
  ini_setting { "forwarder_splunkd_port":
    path    => "${splunk::params::forwarder_confdir}/web.conf",
    section => 'settings',
    setting => 'mgmtHostPort',
    value   => "${splunkd_listen}:${splunkd_port}",
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
    'Linux': { include splunk::platform::linux }
  }

  # Realize resources shared between server and forwarder profiles, and set up
  # dependency chains.
  include splunk::virtual

  Package               <| title  == $package_name      |> ->
  Exec                  <| tag    == 'splunk_forwarder' |> ->
  Service               <| title  == $virtual_service   |>

  Package               <| title  == $package_name      |> ->
  Splunkforwarder_input <| tag    == 'splunk_forwarder' |> ~>
  Service               <| title  == $virtual_service   |>

  Package                <| title == $package_name      |> ->
  Splunkforwarder_output <| tag   == 'splunk_forwarder' |> ~>
  Service                <| title == $virtual_service   |>

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
