class splunk::forwarder (
  $ensure            = present,
  $server            = 'splunk',
  $port              = '8089',
  $package_source    = $splunk::params::splunkforwarder_pkg,
  $splunk_admin      = "admin",
  $splunk_admin_pass = "changeme",
) inherits splunk::params {
  include staging

  $staged_package = staging_parse($package_source)
  $staging_subdir = 'splunk'

  staging::file { $staged_package:
    source => $package_source,
    subdir => $staging_subdir,
  }

  package { $splunk::params::splunkforwarder_pkg_name:
    ensure   => installed,
    provider => $pkg_provider,
    source   => "${staging::path}/${staging_subdir}/${staged_package}",
    require  => Staging::File[$staged_package],
  }

  service { $splunk::params::splunkforwarder_service:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  case $::osfamily {
    default: { } # no special configuration needed
  }

}
