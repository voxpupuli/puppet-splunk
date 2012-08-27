class splunk::windows_server {
  file {"${splunk::params::windows_stage_drive}\\installers":
    ensure => directory;
  }
  file {"splunk_installer":
    path   => "${splunk::params::windows_stage_drive}\\installers\\${installer}", 
    source => $splunk::params::installer_source,
  }
  package {"Splunk":
    source          => "${splunk::params::windows_stage_drive}\\installers\\${installer}",
    install_options => {
      "SPLUNKD_PORT"           => "${splunk::params::splunkd_port}",
      "WEB_PORT"               => "${splunk::params::admin_port}",
      "LAUNCHSPLUNK"           => "1",
      "WINEVENTLOG_APP_ENABLE" => "1",
      "WINEVENTLOG_SEC_ENABLE" => "1",
      "WINEVENTLOG_SYS_ENABLE" => "1",
      "WINEVENTLOG_FWD_ENABLE" => "1",
      "WINEVENTLOG_SET_ENABLE" => "1",
    },
    require         => File['splunk_installer'],
  }
  service {"Splunkd":
    ensure  => running,
    enable  => true,
    require => Package['Splunk'],
  }
  service {"Splunkweb":
    ensure  => running,
    enable  => true,
    require => Service['Splunkd'], 
  }
  exec { "set_listen_port":
    unless  => "findstr.exe /C:\"[splunktcp\://${splunk::params::logging_port}]\" \"C:\\Program Files\\Splunk\\etc\\apps\\search\\local\\inputs.conf\"",
    command => "\"C:\\Program Files\\Splunk\\bin\\splunk.exe\" enable listen ${splunk::params::logging_port} -auth ${splunk::params::splunk_admin}:${splunk::params::splunk_admin_pass}",
    require => Service['Splunkweb'],
  }
  exec { "set_syslog_listen_port":
    unless  => "findstr.exe /C:\"[tcp\://${splunk::params::syslogging_port}]\" \"C:\\Program Files\\Splunk\\etc\\apps\\search\\local\\inputs.conf\"",
    command => "\"C:\\Program Files\\Splunk\\bin\\splunk.exe\" add tcp ${splunk::params::syslogging_port} -sourcetype syslog -auth ${splunk::params::splunk_admin}:${splunk::params::splunk_admin_pass}",
    require => Service['Splunkweb'],
  }
  exec { "splunk-${splunk::params::admin_port}-fw":
    command => "netsh.exe firewall add portopening protocol=TCP profile=ALL ${splunk::params::admin_port} \"Splunk Admin ${splunk::params::admin_port}\"",
    unless  => "cmd.exe /c \"netsh.exe firewall show portopening | findstr.exe /C:\"Splunk Admin ${splunk::params::admin_port}\"\"",
    require => Service['Splunkweb'],
  }
  exec { "splunk-${splunk::params::logging_port}-fw":
    command => "netsh.exe firewall add portopening protocol=TCP profile=ALL ${splunk::params::logging_port} \"Splunk splunktcp ${splunk::params::logging_port}\"", 
    unless  => "cmd.exe /c \"netsh.exe firewall show portopening | findstr.exe /C:\"Splunk splunktcp ${splunk::params::logging_port}\"\"",
    require => Service['Splunkd'],
  }
  exec { "splunk-${splunk::params::syslogging_port}-fw":
    command => "netsh.exe firewall add portopening protocol=TCP profile=ALL ${splunk::params::syslogging_port} \"Splunk syslog tcp ${splunk::params::syslogging_port}\"", 
    unless  => "cmd.exe /c \"netsh.exe firewall show portopening | findstr.exe /C:\"Splunk syslog tcp ${splunk::params::syslogging_port}\"\"",
    require => Service['Splunkd'],
  }
  exec { "splunk-${splunk::params::splunkd_port}-fw":
    command => "netsh.exe firewall add portopening protocol=TCP profile=ALL ${splunk::params::splunkd_port} \"Splunk splunkd ${splunk::params::splunkd_port}\"",
    unless  => "cmd.exe /c \"netsh.exe firewall show portopening | findstr.exe /C:\"Splunk splunkd ${splunk::params::splunkd_port}\"\"",
    require => Service['Splunkd'],
  }
}
