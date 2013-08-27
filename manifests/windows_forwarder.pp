class splunk::windows_forwarder (
  $server,
  $port,
) inherits splunk::params {

  # For convenience, declare local short variables
  $splunkforwarder_pkg = $splunk::params::splunkforwarder_pkg
  $splunk_source       = $splunk::params::source_root
  $windows_stage_drive = $splunk::params::windows_stage_drive

  file { "${windows_stage_drive}\\installers":
    ensure => directory;
  }
  file { "splunk_installer":
    path   => "${windows_stage_drive}\\installers\\${splunkforwarder_pkg}", 
    source => "${splunk_source}/${splunkforwarder_pkg}",
  }

  package { "Universal Forwarder":
    source          => "${windows_stage_drive}\\installers\\${splunkforwarder_pkg}",
    require         => File['splunk_installer'],
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
