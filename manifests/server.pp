class splunk::server (
  $splunk_ver          = '4.3.2-123586',
  $splunk_source       = "puppet:///files/${module_name}",
  $splunk_admin        = "admin",
  $splunk_admin_pass   = "changeme",
  $logging_port        = '9997',
  $admin_port          = '8000',
  $syslogging_port     = '8007',
  $splunkd_port        = '8089',
) inherits splunk::params {

  staging::file { $splunk_pkg:
    source => "${splunk_source}/${splunk_pkg}",
  }

  package {'splunk':
    ensure   => present,
    provider => $splunk::params::pkg_provider,
    source   => "/opt/staging/splunk/${splunk::params::splunk_pkg}",
    require  => Staging::File[$splunk::params::splunk_pkg],
  }

  file { '/opt/splunk/etc/system/local/inputs.conf':
    ensure  => file,
    content => template('splunk/serverinputs.conf.erb'),
    require => Package['splunk'],
    notify  => Service['splunk'],
  }

  service { 'splunk':
    ensure  => running,
    enable  => true,
    require => Exec['enable_splunk'],
  }

  exec { 'license_splunk':
    command => "/opt/splunk/bin/splunk start --accept-license --answer-yes",
    creates => "/opt/splunk/etc/auth/splunk.secret",
    timeout => 0,
    require => Package['splunk'],
  }

  exec { 'enable_splunk':
    command => "/opt/splunk/bin/splunk enable boot-start",
    creates => "/etc/init.d/splunk",
    require => Exec['license_splunk'],
  }

  exec { 'set_listen_port':
    unless  => "/bin/grep '\[splunktcp\:\/\/${logging_port}\]' /opt/splunk/etc/apps/search/local/inputs.conf",
    command => "/opt/splunk/bin/splunk enable listen ${logging_port} -auth ${splunk_admin}:${splunk_admin_pass}",
    require => Exec['license_splunk'],
  }
  exec { 'set_tcp_listen_port':
    unless  => "/bin/grep '\[tcp\:\/\/${syslogging_port}\]' /opt/splunk/etc/apps/search/local/inputs.conf",
    command => "/opt/splunk/bin/splunk add tcp ${syslogging_port} -sourcetype syslog -auth ${splunk_admin}:${splunk_admin_pass}",
    require => Exec['license_splunk'],
  }

  firewall { '100 allow Splunk Console':
    action => "accept",
    proto  => "tcp",
    dport  => "${admin_port}",
  }
  firewall { '100 allow Splunkd':
    action => "accept",
    proto  => "tcp",
    dport  => "${splunkd_port}",
  }
  firewall { '100 allow splunktcp syslog Logging in':
    action => "accept",
    proto  => "tcp",
    dport  => "${logging_port}",
  }
  firewall { '100 allow tcp syslog Logging in':
    action => "accept",
    proto  => "tcp",
    dport  => "${syslogging_port}",
  }

}
