# @summary
#   Private class declared by Class[splunk::edgeprocessor] to contain the required steps
#   for successfully configuring the Systemd service to run the Splunk Edge Processor
#
class splunk::edgeprocessor::service {
  #Customize the default splunk-edge.service file that comes in the archive download
  $service_defaults = { 'path' => "${splunk::edgeprocessor::splunk_homedir}/etc/splunk-edge.service" }
  $service_variables = { 'Service' => { 'ExecStart' => "${splunk::edgeprocessor::splunk_homedir}/bin/splunk-edge run" ,
  'User' => $splunk::edgeprocessor::splunk_user , 'Group' => $splunk::edgeprocessor::splunk_user } }
  inifile::create_ini_settings($service_variables, $service_defaults)

  # Install Systemd unit file
  file { '/etc/systemd/system/splunk-edge.service':
    ensure => file,
    source => "${splunk::edgeprocessor::splunk_homedir}/etc/splunk-edge.service",
    notify => Exec['systemd_reload'],
  }

  exec { 'systemd_reload':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
    notify      => Service['splunk-edge'],
  }

  service { 'splunk-edge':
    ensure => true,
    enable => true,
  }
}
