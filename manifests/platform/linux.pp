class splunk::platform::linux inherits splunk::virtual {

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

  # Commands to run to enable the SplunkUniversalForwarder
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

  # Commands to run to enable full Splunk
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

  # Default inputs/outputs to create on Linux systems
  @splunkforwarder_input { 'monitor_varlog':
    section => 'monitor://var/log/',
    setting => 'host',
    value   => $::clientcert,
    tag     => 'splunk_forwarder',
  }

}
