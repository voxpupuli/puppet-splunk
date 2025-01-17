# @summary
#   Define and contain the services for Splunk Enterprise Server.
#
class splunk::enterprise::service {
  service { $splunk::enterprise::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
