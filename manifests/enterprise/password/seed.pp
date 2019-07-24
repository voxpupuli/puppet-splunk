# @summary
#   Implements the seeding and reseeding of the Splunk Enterprise admin password
#   so it can be used outside of regular management of the whole stack to
#   facilitate admin password resets through Bolt Plans
#
# @param seed_password
#   If set to true, Manage the contents of splunk.secret and user-seed.conf.
#
# @param reset_seed_password
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
class splunk::enterprise::password::seed(
  Boolean $reset_seeded_password             = lookup($splunk::enterprise::reset_seeded_password),
  Stdlib::Absolutepath $password_config_file = lookup($splunk::enterprise::password_config_file),
  Stdlib::Absolutepath $seed_config_file     = lookup($splunk::enterprise::seed_config_file),
  String[1] $password_hash                   = lookup($splunk::enterprise::password_hash),
  Stdlib::Absolutepath $secret_file          = lookup($splunk::enterprise::secret_file),
  String[1] $secret                          = lookup($splunk::enterprise::secret),
  String[1] $splunk_user                     = lookup($splunk::enterprise::splunk_user),
  Enum['agent', 'bolt'] $mode                = 'bolt',
  Optional[String[1]] $service               = undef,
) {

  if $mode == 'bolt' and !$service {
    fail('You must specify $splunk::enterprise::password::seed::service` for Bolt')
  }

  file { $secret_file:
    ensure  => file,
    owner   => $splunk_user,
    group   => $splunk_user,
    content => $secret,
  }

  if $reset_seeded_password or $facts['splunkenterprise']['version'].empty {
    file { $password_config_file:
      ensure => absent,
      before => File[$seed_config_file],
    }
    file { $seed_config_file:
      ensure  => file,
      owner   => $splunk_user,
      group   => $splunk_user,
      content => epp('splunk/user-seed.conf.epp', { 'hash' => $password_hash}),
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
