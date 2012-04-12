class splunk::linux_server {
  file {"${splunk::params::linux_stage_dir}":
    ensure => directory,
    owner  => "root",
    group  => "root",
  }
  file {"splunk_installer":
    path    => "${splunk::params::linux_stage_dir}/${splunk::params::installer}",
    source  => "puppet:///modules/${module_name}/${splunk::params::installer}",
    require => File["${splunk::params::linux_stage_dir}"],
  }
  firewall { "100 allow Splunk Console":
    action => "accept",
    proto  => "tcp",
    dport  => "${splunk::params::admin_port}",
  }
  firewall { "100 allow Splunkd":
    action => "accept",
    proto  => "tcp",
    dport  => "${splunk::params::splunkd_port}",
  }
  firewall { "100 allow splunktcp syslog Logging in":
    action => "accept",
    proto  => "tcp",
    dport  => "${splunk::params::logging_port}",
  }
  firewall { "100 allow tcp syslog Logging in":
    action => "accept",
    proto  => "tcp",
    dport  => "${splunk::params::syslogging_port}",
  }
  package {"splunk":
    ensure   => installed,
    source   => "${splunk::params::linux_stage_dir}/${splunk::params::installer}",
    provider => $::operatingsystem ? {
      /(?i)(centos|redhat)/ => 'rpm',
      'debian'            => 'dpkg',
    },
    notify   => Exec['start_splunk'],
  }
  exec {"start_splunk":
    creates => "/opt/splunk/etc/auth/splunkweb",
    command => "/opt/splunk/bin/splunk start --accept-license",
    timeout => 0,
    notify  => Exec['set_boot','set_listen_port','set_tcp_listen_port'],
  }
  exec {"set_boot":
    creates => "/etc/init.d/splunk",
    command => "/opt/splunk/bin/splunk enable boot-start",
  }
  exec {"set_listen_port":
    unless  => "/bin/grep '\[splunktcp\:\/\/${splunk::params::logging_port}\]' /opt/splunk/etc/apps/search/local/inputs.conf",
    command => "/opt/splunk/bin/splunk enable listen ${splunk::params::logging_port} -auth ${splunk::params::splunk_admin}:${splunk::params::splunk_admin_pass}",
  }
  exec {"set_tcp_listen_port":
    unless  => "/bin/grep '\[tcp\:\/\/${splunk::params::syslogging_port}\]' /opt/splunk/etc/apps/search/local/inputs.conf",
    command => "/opt/splunk/bin/splunk add tcp ${splunk::params::syslogging_port} -sourcetype syslog -auth ${splunk::params::splunk_admin}:${splunk::params::splunk_admin_pass}",
  }
  service {"splunk":
    enable      => true,
    require     => Exec['set_boot'],
  }
  service {"splunkd":
    ensure   => running,
    provider => "base",
    restart  => "/opt/splunk/bin/splunk restart splunkd",
    start    => "/opt/splunk/bin/splunk start splunkd",
    stop     => "/opt/splunk/bin/splunk stop splunkd",
    pattern  => "splunkd -p ${splunk::params::splunkd_port} (restart|start)",
    require  => Service['splunk'],
  }
  service {"splunkweb":
    ensure   => running,
    provider => "base",
    restart  => "/opt/splunk/bin/splunk restart splunkweb",
    start    => "/opt/splunk/bin/splunk start splunkweb",
    stop     => "/opt/splunk/bin/splunk stop splunkweb",
    pattern  => "python -O /opt/splunk/lib/python.*/splunk/.*/root.py (restart|start)",
    require  => Service['splunk'],
  }
}
