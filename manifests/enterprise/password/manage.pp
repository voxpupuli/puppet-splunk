# @summary
#   Implements the direct management of the Splunk Enterprise admin password
#   so it can be used outside of regular management of the whole stack to
#   facilitate admin password resets through Bolt Plans.
#
#   Note: Entirely done to make this implementation consistent with the method
#   used to manage admin password seeding.
#
# @param manage_password
#   If set to true, Manage the contents of splunk.secret and passwd.
#
# @param password_config_file
#   Which file to put the password in i.e. in linux it would be
#   `/opt/splunk/etc/passwd`.
#
# @param password_content
#   The hashed password username/details for the user.
# @param secret_file
#   Which file we should put the secret in.
#
# @param secret
#   The secret used to salt the splunk password.
#
# @params service
#   Name of the Splunk Enterprise service that needs to be restarted after files
#   are updated, not applicable when running in agent mode.
#
# @params mode
#   The class is designed to work in two ways, as a helper that is called by
#   Class[splunk::enterprise::config] or leveraged independently from with in a
#   Bolt Plan. The value defaults to "bolt" implicitly assuming that anytime it
#   is used outside of Class[splunk::enterprise::config], it is being used by
#   Bolt
#
class splunk::enterprise::password::manage(
  Boolean $manage_password                   = $splunk::params::manage_password,
  Stdlib::Absolutepath $password_config_file = $splunk::params::forwarder_password_config_file,
  String[1] $password_content                = $splunk::params::password_content,
  Stdlib::Absolutepath $secret_file          = $splunk::params::forwarder_secret_file,
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

  file { $password_config_file:
    ensure  => file,
    owner   => $splunk_user,
    group   => $splunk_user,
    content => $password_content,
    require => File[$secret_file],
  }

  if $mode == 'bolt' {
    service { $service:
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => File[$password_config_file],
    }
  }
}
