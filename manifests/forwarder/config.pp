# Class splunk::forwarder::config
#
class splunk::forwarder::config {

  if $splunk::forwarder::manage_password {
    file { $splunk::forwarder::password_config_file:
      ensure  => file,
      owner   => $splunk::forwarder::splunk_user,
      group   => $splunk::forwarder::splunk_user,
      content => $splunk::forwarder::password_content,
    }

    file { $splunk::forwarder::secret_file:
      ensure  => file,
      owner   => $splunk::forwarder::splunk_user,
      group   => $splunk::forwarder::splunk_user,
      content => $splunk::forwarder::secret,
    }
  }

  # Remove init.d file if the service provider is systemd
  if $facts['service_provider'] == 'systemd' and versioncmp($splunk::forwarder::version, '7.2.2') >= 0 {
    file { '/etc/init.d/splunk':
      ensure => 'absent',
    }
  }


  $_forwarder_file_mode = $facts['kernel'] ? {
    'windows' => undef,
    default   => '0600',
  }

  file { ["${splunk::forwarder::forwarder_homedir}/etc/system/local/deploymentclient.conf",
          "${splunk::forwarder::forwarder_homedir}/etc/system/local/outputs.conf",
          "${splunk::forwarder::forwarder_homedir}/etc/system/local/inputs.conf",
          "${splunk::forwarder::forwarder_homedir}/etc/system/local/props.conf",
          "${splunk::forwarder::forwarder_homedir}/etc/system/local/transforms.conf",
          "${splunk::forwarder::forwarder_homedir}/etc/system/local/web.conf",
          "${splunk::forwarder::forwarder_homedir}/etc/system/local/limits.conf",
          "${splunk::forwarder::forwarder_homedir}/etc/system/local/server.conf"]:
    ensure => file,
    tag    => 'splunk_forwarder',
    owner  => $splunk::forwarder::splunk_user,
    group  => $splunk::forwarder::splunk_user,
    mode   => $_forwarder_file_mode,
  }

  if $splunk::forwarder::use_default_config {
    splunkforwarder_web { 'forwarder_splunkd_port':
      section => 'settings',
      setting => 'mgmtHostPort',
      value   => "${splunk::forwarder::splunkd_listen}:${splunk::forwarder::splunkd_port}",
      tag     => 'splunk_forwarder',
    }

    $splunk::forwarder::forwarder_input.each | String $name, Hash $options| {
      splunkforwarder_input { $name:
        section => $options['section'],
        setting => $options['setting'],
        value   => $options['value'],
        tag     => 'splunk_forwarder',
      }
    }
    $splunk::forwarder::forwarder_output.each | String $name, Hash $options| {
      splunkforwarder_output { $name:
        section => $options['section'],
        setting => $options['setting'],
        value   => $options['value'],
        tag     => 'splunk_forwarder',
      }
    }
  }

  # Declare addons
  create_resources('splunk::addon', $splunk::forwarder::addons)

  File <| tag == 'splunk_forwarder' |> -> Splunkforwarder_deploymentclient<||> ~> Class['splunk::forwarder::service']
  File <| tag == 'splunk_forwarder' |> -> Splunkforwarder_input<||>            ~> Class['splunk::forwarder::service']
  File <| tag == 'splunk_forwarder' |> -> Splunkforwarder_output<||>           ~> Class['splunk::forwarder::service']
  File <| tag == 'splunk_forwarder' |> -> Splunkforwarder_props<||>            ~> Class['splunk::forwarder::service']
  File <| tag == 'splunk_forwarder' |> -> Splunkforwarder_transforms<||>       ~> Class['splunk::forwarder::service']
  File <| tag == 'splunk_forwarder' |> -> Splunkforwarder_web<||>              ~> Class['splunk::forwarder::service']
  File <| tag == 'splunk_forwarder' |> -> Splunkforwarder_limits<||>           ~> Class['splunk::forwarder::service']
  File <| tag == 'splunk_forwarder' |> -> Splunkforwarder_server<||>           ~> Class['splunk::forwarder::service']

}
