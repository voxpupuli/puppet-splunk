# @summary
#   Define and contain the services for Splunk Forwarder.
#
class splunk::forwarder::service {
  service { $splunk::forwarder::service_name:
    ensure     => $splunk::forwarder::service_ensure,
    enable     => $splunk::forwarder::service_enable,
    hasstatus  => true,
    hasrestart => true,
    provider   => $facts['service_provider'],
  }
}
