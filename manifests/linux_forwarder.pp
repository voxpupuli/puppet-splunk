class splunk::linux_forwarder (
  $server            = 'master',
  $port              = '9997',
  $splunk_ver        = '4.3.2-123586',
  $splunk_source     = "puppet:///files/${module_name}",
  $splunk_admin      = "admin",
  $splunk_admin_pass = "changeme",
) inherits splunk::params {

  staging::file { $splunk::params::splunkforwarder_pkg:
    source => "${splunk_source}/${splunkforwarder_pkg}",
  }

  package { 'splunkforwarder':
    ensure   => present,
    provider => $pkg_provider,
    source   => "/opt/staging/splunk/${splunk::params::splunkforwarder_pkg}",
    require  => Staging::File[$splunk::params::splunkforwarder_pkg],
  }

  file { '/opt/splunkforwarder/etc/system/local/inputs.conf':
    ensure  => file,
    content => template('splunk/inputs.conf.erb'),
    require => Package['splunkforwarder'],
    notify  => Service['splunk'],
  }

  file { '/opt/splunkforwarder/etc/system/local/outputs.conf':
    ensure  => file,
    content => template('splunk/outputs.conf.erb'),
    require => Package['splunkforwarder'],
    notify  => Service['splunk'],
  }

  service { 'splunk':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Exec['enable_splunk'],
  }

  exec { 'license_splunk':
    command => "/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes",
    creates => "/opt/splunkforwarder/etc/auth/splunk.secret",
    timeout => 0,
    require => Package['splunkforwarder'],
  }

  exec { 'enable_splunk':
    command => "/opt/splunkforwarder/bin/splunk enable boot-start",
    creates => "/etc/init.d/splunk",
    require => Exec['license_splunk'],
  }

}
