class splunk::platform::linux {

  @exec { 'license_splunkforwarder':
    path    => '/opt/splunkforwarder/bin',
    command => 'splunk start --accept-license --answer-yes',
    creates => '/opt/splunkforwarder/etc/auth/splunk.secret',
    timeout => 0,
    tag     => 'splunk_forwarder',
  }
  @exec { 'enable_splunkforwarder':
    path    => '/opt/splunkforwarder/bin',
    command => 'splunk enable boot-start',
    creates => '/etc/init.d/splunk',
    require => Exec['license_splunkforwarder'],
    tag     => 'splunk_forwarder',
  }

  @exec { 'license_splunk':
    path    => '/opt/splunk/bin',
    command => 'splunk start --accept-license --answer-yes',
    creates => '/opt/splunk/etc/auth/splunk.secret',
    timeout => 0,
    tag     => 'splunk_server',
  }
  @exec { 'enable_splunk':
    path    => '/opt/splunk/bin',
    command => 'splunk enable boot-start',
    creates => '/etc/init.d/splunk',
    require => Exec['license_splunk'],
    tag     => 'splunk_server',
  }

}
