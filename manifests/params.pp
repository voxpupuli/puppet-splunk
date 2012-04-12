class splunk::params {
  $deploy              = $::splunk_deploy #valid values are server, syslog, forwarder
  $splunk_ver          = '4.3.1-119532'
  $installer           = $deploy ? {
                           'server' => $::architecture ? {
                             'i386' => $::operatingsystem ? {
                               'windows'           => $::path ? {
                                 #This evaluation is in here because of an issue identifying some windows architectures
                                 /\(x86\)/          => "splunk-${splunk_ver}-x64-release.msi",
                                 default           => "splunk-${splunk_ver}-x86-release.msi",
                               },
                               /(?i)(centos|redhat)/ => "splunk-${splunk_ver}.i386.rpm",
                               'debian'            => "splunk-${splunk_ver}-linux-2.6-intel.deb",
                             },
                             'x86_64' => $::operatingsystem ? {
                               'windows'           => "splunk-${splunk_ver}-x64-release.msi",
                               /(?i)(centos|redhat)/ => "splunk-${splunk_ver}-linux-2.6-x86_64.rpm",
                               'debian'            => "splunk-${splunk_ver}-linux-2.6-amd64.deb",
                             },
                           },
                           'forwarder' => $::architecture ? {
                             'i386' => $::operatingsystem ? {
                               'windows'           => $::path ? {
                                 #This evaluation is in here because of an issue identifying some windows architectures
                                 /\(x86\)/           => "splunkforwarder-${splunk_ver}-x64-release.msi",
                                 default             => "splunkforwarder-${splunk_ver}-x86-release.msi",
                               },
                               /(?i)(centos|redhat)/   => "splunkforwarder-${splunk_ver}.i386.rpm",
                               /(?i)(debian|ubuntu)/ => "splunkforwarder-${splunk_ver}-linux-2.6-intel.deb",
                             },
                             'x86_64' => $::operatingsystem ? {
                               'windows'             => "splunkforwarder-${splunk_ver}-x64-release.msi",
                               /(?i)(centos|redhat)/   => "splunkforwarder-${splunk_ver}-linux-2.6-x86_64.rpm",
                               /(?i)(debian|ubuntu)/ => "splunkforwarder-${splunk_ver}-linux-2.6-amd64.deb",
                             },
                           },
                           'syslog' => undef,
                         }
  $logging_server      = $::splunk_logging_server #not validated, but should be hostname or IP
  $syslogging_port     = $::splunk_syslog_port
  $logging_port        = $::splunk_forwarder_port
  $splunkd_port	       = '8089'
  $admin_port          = '8000'
  $linux_stage_dir     = "/usr/local/installers"
  $windows_stage_drive = "C:"
  $splunk_admin        = "admin"
  $splunk_admin_pass   = "changeme"
}
