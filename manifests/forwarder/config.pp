# @summary
#   Private class declared by Class[splunk::forwarder] to contain all the
#   configuration needed for a base install of the Splunk Universal
#   Forwarder
#
class splunk::forwarder::config {

  if $splunk::forwarder::seed_password {
    class { 'splunk::forwarder::password::seed':
      reset_seeded_password => $splunk::forwarder::reset_seeded_password,
      password_config_file  => $splunk::forwarder::password_config_file,
      seed_config_file      => $splunk::forwarder::seed_config_file,
      password_hash         => $splunk::forwarder::password_hash,
      secret_file           => $splunk::forwarder::secret_file,
      secret                => $splunk::forwarder::secret,
      splunk_user           => $splunk::forwarder::splunk_user,
      mode                  => 'agent',
    }
  }

  if $splunk::forwarder::manage_password {
    class { 'splunk::forwarder::password::manage':
      manage_password      => $splunk::forwarder::manage_password,
      password_config_file => $splunk::forwarder::password_config_file,
      password_content     => $splunk::forwarder::password_content,
      secret_file          => $splunk::forwarder::secret_file,
      secret               => $splunk::forwarder::secret,
      splunk_user          => $splunk::forwarder::splunk_user,
      mode                 => 'agent',
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
