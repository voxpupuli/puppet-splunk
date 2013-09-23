class splunk::forwarder::linux {
  include splunk::params

  exec { 'license_splunk':
    command => "/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes",
    creates => "/opt/splunkforwarder/etc/auth/splunk.secret",
    timeout => 0,
    require => Package[$splunk::params::forwarder_pkg_name],
    before  => Service[$splunk::params::forwarder_service],
  } ->

  exec { 'enable_splunk':
    command => "/opt/splunkforwarder/bin/splunk enable boot-start",
    creates => "/etc/init.d/splunk",
    require => Package[$splunk::params::forwarder_pkg_name],
    before  => Service[$splunk::params::forwarder_service],
  }

}
