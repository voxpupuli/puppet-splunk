# @summary
#   Private class declared by Class[splunk::forwarder] to define a service as
#   its understood by Puppet using a dynamic set of data or platform specific
#   sub-classes
#
class splunk::forwarder::service {

  # This is a module that supports multiple platforms. For some platforms
  # there is non-generic configuration that needs to be declared in addition
  # to the agnostic resources declared here.
  if $facts['kernel'] in ['Linux', 'SunOS'] {
    include splunk::forwarder::service::nix
  }

  service { $splunk::forwarder::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
