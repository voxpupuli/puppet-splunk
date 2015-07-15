# Class: splunk
#
# This class distributes a password for the admin user that would enable the splunk admins to
# manage several systems at once
# To find the right variables for splunkforwarder, manually create a splunkforwarder, change the password and
# distribute the contents of the splunk.secret and passwd files accross nodes.
# By default the parameters provided are for admin/changeme password.
#
# Parameters:
#
# [*server*]

# [*password_config_file*]
#  which file to put the password in i.e. in linux it would be /opt/splunkforwarder/etc/passwd
#
# [*secret_file*]
#  which file we should put the secret in
#
# [*passord_content*]
# the hashed password username/details for the user
#
# [*service_password*]
#  are we passwording splunkforwarder or splunk - currently tested with splunkforwarder only
#
# [*license*]
# which service we should expect the licesnse to be accepted for
#
# sponsored by balgroup
class splunk::password( $password_config_file = $splunk::params::password_config_file,
                        $secret_file          = $splunk::params::secret_file,
                        $secret               = $splunk::params::secret,
                        $password_content     = $splunk::params::password_content,
                        $service_password     = 'splunk_forwarder',
                        $virtual_service      = $splunk::params::forwarder_service,
                        $license              = 'license_splunkforwarder',
                        $package_name         = $splunk::params::forwarder_pkg_name,
                      ) inherits splunk::params {
  if ! defined(Class['splunk::forwarder']) and ! defined(Class['splunk']){
    fail('You must include the splunk forwarder or splunk class before changing the password defined resources')
  }

  file { "$password_config_file":
    content => $password_content,
    ensure  => present,
    require => Package[$package_name],
    notify  => Service[$virtual_service],
    tag     => "splunk_password",
  }

  file { "$secret_file":
    content => $secret,
    require => Package[$package_name],
    notify  => Service[$virtual_service],
    ensure  => present,
  }
  

}
