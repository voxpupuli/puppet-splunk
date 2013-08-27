class splunk (
  $port              = '9997',
  $splunk_ver        = '4.3.2-123586',
  $splunk_source     = "puppet:///files/${module_name}",
  $splunk_admin      = "admin",
  $splunk_admin_pass = "changeme",
  $server,
) {

  case $::kernel {
    /(?i)linux/: {
      class { '::splunk::linux_forwarder':
        server             => $server,
        port               => $port,
        splunk_ver         => $splunk_ver,
        splunk_source      => $splunk_source,
        splunk_admin       => $splunk_admin,
        splunk_admin_pass  => $splunk_admin_pass,
      }
    }
    /(?i)sunos/: {
      class { "splunk::solaris_forwarder":
        server => $server,
        port   => $port,
      }
    }
    /(?i)windows/: {
      class { '::splunk::windows_forwarder':
        server => $server,
        port   => $port,
      }
      Exec {
        path => "${::path}\;\"C:\\Program Files\\Splunk\\bin\""
      }
    }
  }

}
