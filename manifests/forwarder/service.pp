# @summary
#   Private class declared by Class[splunk::forwarder] to define a service as
#   its understood by Puppet using a dynamic set of data or platform specific
#   sub-classes
#
class splunk::forwarder::service {

  service { $splunk::forwarder::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
