class splunk::master 
{
  include splunk

  ini_setting {
    "splunk_master_node":
      path    => "${splunk::params::server_confdir}/server.conf",
      section => 'clustering',
      setting => 'mode',
      value   => 'master',
      require => Package[$splunk::package_name],
      notify  => Service[$splunk::virtual_service];
    "splunk_replication_factor":
      path    => "${splunk::params::server_confdir}/server.conf",
      section => 'clustering',
      setting => 'replication_factor',
      value   => "$splunk::replication_factor",
      require => Package[$splunk::package_name],
      notify  => Service[$splunk::virtual_service];
    "splunk_search_factor":
      path    => "${splunk::params::server_confdir}/server.conf",
      section => 'clustering',
      setting => 'search_factor',
      value   => "$splunk::search_factor",
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
