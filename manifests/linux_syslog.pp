class splunk::linux_syslog {
  package {"rsyslog":
    ensure => installed,
  }
  service {"rsyslog":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['rsyslog'],
  }
  file {"/etc/rsyslog.conf":
    ensure  => file,
    mode    => '0644',
    owner   => "root",
    group   => "root",
    require => Package['rsyslog'],
  }
  file_line {"log_all":
    ensure  => present, 
    path    => '/etc/rsyslog.conf',
    line    => "*.*	@@${splunk::params::logging_server}:${splunk::params::syslogging_port}",
    require => File['/etc/rsyslog.conf'],
    notify  => Service['rsyslog'],
  } 
}
