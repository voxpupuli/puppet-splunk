# @summary
#   Implements seeding and reseeding of Splunk Enterprise admin password to
#   support admin password resets via Bolt.
#
# @param reset_seeded_password
#   If set to true, deletes `password_config_file` to trigger Splunk's password
#   import process on restart of the Splunk services.
#
# @param password_config_file
#   Which file to put the password in i.e. in linux it would be
#   `/opt/splunk/etc/passwd`.
#
# @param seed_config_file
#   Which file to place the admin password hash in so its imported by Splunk on
#   restart.
#
# @param seed_user
#   The local user (usually 'admin') imported by Splunk.
#
# @param password_hash
#   The hashed password for the admin user.
#
# @param secret_file
#   Which file we should put the secret in.
#
# @param secret
#   The secret used to salt the splunk password.
#
# @param service
#   Name of the Splunk Enterprise service that needs to be restarted after files
#   are updated, not applicable when running in agent mode.
#
# @param mode
#   The class is designed to work in two ways, as a helper that is called by
#   Class[splunk::enterprise::config] or leveraged independently from with in a
#   Bolt Plan. The value defaults to "bolt" implicitly assuming that anytime it
#   is used outside of Class[splunk::enterprise::config], it is being used by
#   Bolt
#
class splunk::enterprise::password::seed (
  Boolean $reset_seeded_password             = $splunk::params::reset_seeded_password,
  Stdlib::Absolutepath $password_config_file = $splunk::params::enterprise_password_config_file,
  Stdlib::Absolutepath $seed_config_file     = $splunk::params::enterprise_seed_config_file,
  String[1] $seed_user                       = $splunk::params::seed_user,
  String[1] $password_hash                   = $splunk::params::password_hash,
  Stdlib::Absolutepath $secret_file          = $splunk::params::enterprise_secret_file,
  String[1] $secret                          = $splunk::params::secret,
  String[1] $splunk_user                     = $splunk::params::splunk_user,
  String[1] $service                         = $splunk::params::enterprise_service,
  Enum['agent', 'bolt'] $mode                = 'bolt',
) inherits splunk::params {
  file { $secret_file:
    ensure  => file,
    owner   => $splunk_user,
    group   => $splunk_user,
    content => $secret,
  }

  if $reset_seeded_password or $facts['splunk_version'].empty {
    file { $password_config_file:
      ensure => absent,
      before => File[$seed_config_file],
    }
    file { $seed_config_file:
      ensure  => file,
      owner   => $splunk_user,
      group   => $splunk_user,
      content => epp('splunk/user-seed.conf.epp', { 'user' => $seed_user, 'hash' => $password_hash }),
      require => File[$secret_file],
    }

    if $mode == 'bolt' {
      service { $service:
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        subscribe  => File[$seed_config_file],
      }
    }
  }
}
