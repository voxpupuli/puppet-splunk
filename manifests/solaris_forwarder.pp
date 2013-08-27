class splunk::solaris_forwarder (
  $server              = $splunk::params::logging_server,
  $port                = $splunk::params::logging_port,
  $splunkforwarder_pkg = $splunk::params::splunkforwarder_pkg,
  $splunk_source       = $splunk::params::source_root,
) inherits splunk::params {

  staging::file { $splunkforwarder_pkg:
    source => "${splunk_source}/${splunkforwarder_pkg}",
  }

  package { "splunkforwarder":
    ensure       => installed,
    source       => "/opt/staging/splunk/${splunkforwarder_pkg}",
    provider     => sun,
    adminfile    => "/var/sadm/install/admin/splunk-noask",
    notify       => Exec['license_splunk'],
    require      => File['splunk_pkg_response_file'],
    responsefile => "/opt/staging/splunk/response.txt",
  }

  file { '/opt/splunkforwarder/etc/system/local/outputs.conf':
    ensure  => file,
    content => template('splunk/outputs.conf.erb'),
    require => Package['splunkforwarder'],
    notify  => Service['splunk'],
  }

  service {"splunk":
    ensure     => running,
    enable     => true,
    provider   => init,
    hasstatus  => true,
    hasrestart => true,
    require    => Exec['enable_splunk'],
  }

  file { "splunk_pkg_response_file":
    ensure  => file,
    owner   => "root",
    group   => "root",
    path    => "/opt/staging/splunk/response.txt",
    content => "BASEDIR=/opt\n",
    require => Staging::File[$splunkforwarder_pkg],
  }

  file { "splunk_adminfile":
    path    => "/var/sadm/install/admin/splunk-noask",
    ensure  => file,
    owner   => root,
    group   => root,
    source => "puppet:///modules/splunk/splunk-noask",
    before  => Package['splunkforwarder'],
  }

  exec { 'license_splunk':
    command => "/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes",
    creates => "/opt/splunkforwarder/etc/auth/splunk.secret",
    timeout => 0,
    require => Package['splunkforwarder'],
  }

  exec { 'enable_splunk':
    command => "/opt/splunkforwarder/bin/splunk enable boot-start",
    creates => "/etc/init.d/splunk",
    require => Exec['license_splunk'],
  }

  exec { "set_monitor_default":
    unless  => "/bin/grep \"\/var\/log\" /opt/splunkforwarder/etc/apps/search/local/inputs.conf",
    command => "/opt/splunkforwarder/bin/splunk add monitor \"/var/log/\" -auth ${splunk::params::splunk_admin}:${splunk::params::splunk_admin_pass}",
    require => Exec['license_splunk','enable_splunk'],
  }

}
