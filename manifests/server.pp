class splunk::server (
  $package_source = $splunk::params::server_pkg_src,
  $logging_port   = $splunk::params::logging_port,
  $admin_port     = $splunk::params::admin_port,
  $splunkd_port   = $splunk::params::splunkd_port,
) inherits splunk::params {
  include staging

  $staged_package = staging_parse($package_source)
  $staging_subdir = 'splunk'

  staging::file { $staged_package:
    source => $package_source,
    subdir => $staging_subdir,
    before => Package['splunk'],
  }

  package { $splunk::params::server_pkg_name:
    ensure   => installed,
    provider => $splunk::params::pkg_provider,
    source   => "${staging::path}/${staging_subdir}/${staged_package}",
    before   => Service[$splunk::params::server_virtual_service],
  }

  include splunk::virtual
  realize(Service[$splunk::params::server_virtual_service])

  file { '/opt/splunk/etc/system/local/inputs.conf':
    ensure  => file,
    content => template('splunk/serverinputs.conf.erb'),
    require => Package[$splunk::params::server_pkg_name],
    notify  => Service[$splunk::params::server_pkg_name],
  }

  case $::kernel {
    default: { } # no special configuration needed
    'Linux': { include splunk::platform::linux }
  }

}
