# @summary
#   Private class declared by Class[splunk::enterprise] to define a service
#   as its understood by Puppet using a dynamic set of data or platform specific
#   sub-classes
#
class splunk::enterprise::service {

  service { $splunk::enterprise::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
