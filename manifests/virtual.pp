class splunk::virtual {
  include splunk::params

  $virtual_services = unique(flatten([
    $splunk::params::server_service,
    $splunk::params::forwarder_service,
  ]))

  @service { $virtual_services:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
