# @summary
#   Private class declared by Class[splunk::forwarder] to define a service as
#   its understood by Puppet using a dynamic set of data or platform specific
#   sub-classes
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
