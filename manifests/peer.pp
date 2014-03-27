class splunk::peer 
{
  include splunk

  ini_setting { 
    "splunk_peer_node":
      path    => "${splunk::params::server_confdir}/server.conf",
      section => 'clustering',
      setting => 'mode',
      value   => 'slave',
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

  # This is disgusting, but since it could change I don't see how to use 
  # ini_setting. Other option would be to manage the entire file?
  exec {
    "add_replication_port":
      command => "/bin/echo [replication_port://$splunk::replication_port] >> ${splunk::params::server_confdir}/server.conf",
      unless => "/bin/grep \"\\[replication_port://$splunk::replication_port\\]\" ${splunk::params::server_confdir}/server.conf";
    "update_replication_port":
      command => "/bin/sed -i \"s#\\[replication_port://\\([0-9]\\+\\)\\]#[replication_port://$splunk::replication_port]#g\" ${splunk::params::server_confdir}/server.conf",
      unless => "/bin/grep \"\\[replication_port://$splunk::replication_port\\]\" ${splunk::params::server_confdir}/server.conf",
      before => Exec['add_replication_port'];
}

}
