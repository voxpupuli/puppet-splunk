# @summary
#   Private class declared by Class[splunk::forwarder] to define a service as
#   its understood by Puppet using a dynamic set of data or platform specific
#   sub-classes
#
class splunk::forwarder::service {
  if $splunk::forwarder::package_ensure == absent {
    service { $splunk::forwarder::service_name:
      ensure     => stopped,
      enable     => false,
      hasstatus  => false,
      hasrestart => false,
    }
  } else {
    service { $splunk::forwarder::service_name:
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
