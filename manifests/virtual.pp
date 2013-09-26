class splunk::virtual {
  include splunk::params

  @service { 'splunk':
    ensure     => running,
    name       => $splunk::params::server_service,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  @service { 'splunkforwarder':
    ensure     => running,
    name       => $splunk::params::forwarder_service,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
