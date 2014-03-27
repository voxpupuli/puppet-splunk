class splunk::searchhead 
{
  include splunk

  ini_setting { 
    "splunk_peer_node":
      path    => "${splunk::params::server_confdir}/server.conf",
      section => 'clustering',
      setting => 'mode',
      value   => 'searchhead',
      require => Package[$splunk::package_name],
      notify  => Service[$splunk::virtual_service];
    "splunk_master_uri":
      path    => "${splunk::params::server_confdir}/server.conf",
      section => 'clustering',
      setting => 'master_uri',
      value   => "$splunk::master_uri",
      require => Package[$splunk::package_name],
      notify  => Service[$splunk::virtual_service];
    "splunk_pass4SymmKey":
      path    => "${splunk::params::server_confdir}/server.conf",
      section => 'clustering',
      setting => 'pass4SymmKey',
      value   => "$splunk::pass4SymmKey",
      require => Package[$splunk::package_name],
      notify  => Service[$splunk::virtual_service];
  }
}
