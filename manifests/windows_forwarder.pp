class splunk::windows_forwarder {

  $server = $splunk::params::logging_server
  $port   = $splunk::params::logging_port

  # Installation source files
  file {"${splunk::params::windows_stage_drive}\\installers":
    ensure => directory;
  }
  file {"splunk_installer":
    path   => "${splunk::params::windows_stage_drive}\\installers\\${installer}", 
    source => $splunk::params::installer_source,
  }

  # System resources
  package {"Universal Forwarder":
    source          => "${splunk::params::windows_stage_drive}\\installers\\${installer}",
    install_options => {
      "AGREETOLICENSE"         => 'Yes',
      "RECEIVING_INDEXER"      => "${server}:${port}",
      "LAUNCHSPLUNK"           => "1",
      "SERVICESTARTTYPE"       => "auto",
      "WINEVENTLOG_APP_ENABLE" => "1",
      "WINEVENTLOG_SEC_ENABLE" => "1",
      "WINEVENTLOG_SYS_ENABLE" => "1",
      "WINEVENTLOG_FWD_ENABLE" => "1",
      "WINEVENTLOG_SET_ENABLE" => "1",
      "ENABLEADMON"            => "1",
    },
    require         => File['splunk_installer'],
  }
  file { 'C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf':
    ensure  => file,
    content => template('splunk/outputs.conf.erb'),
    require => Package['Universal Forwarder'],
    notify  => Service['SplunkForwarder'],
  }
  service { 'SplunkForwarder':
    ensure  => running,
    enable  => true,
    require => Package['Universal Forwarder'],
  }
}
