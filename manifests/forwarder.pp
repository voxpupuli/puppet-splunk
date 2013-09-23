class splunk::forwarder (
  $ensure            = present,
  $server            = 'splunk',
  $logging_port      = $splunk::params::logging_port,
  $package_source    = $splunk::params::forwarder_pkg_src,
) inherits splunk::params {
  include staging

  $staged_package = staging_parse($package_source)
  $staging_subdir = 'splunk'

  staging::file { $staged_package:
    source => $package_source,
    subdir => $staging_subdir,
    before => Package[$splunk::params::forwarder_pkg_name],
  }

  package { $splunk::params::forwarder_pkg_name:
    ensure   => installed,
    provider => $pkg_provider,
    source   => "${staging::path}/${staging_subdir}/${staged_package}",
    before   => Service[$splunk::params::forwarder_virtual_service],
  }

  include splunk::virtual
  realize(Service[$splunk::params::forwarder_virtual_service])

  file { "${splunk::params::config_dir}/inputs.conf":
    ensure  => file,
    content => template('splunk/inputs.conf.erb'),
    require => Package[$splunk::params::forwarder_pkg_name],
    notify  => Service[$splunk::params::forwarder_virtual_service],
  }

  file { "${splunk::params::config_dir}/outputs.conf":
    ensure  => file,
    content => template('splunk/outputs.conf.erb'),
    require => Package[$splunk::params::forwarder_pkg_name],
    notify  => Service[$splunk::params::forwarder_virtual_service],
  }

  case $::kernel {
    default: { } # no special configuration needed
    'Linux': { include splunk::platform::linux }
  }

}
