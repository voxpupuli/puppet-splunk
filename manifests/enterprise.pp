# @summary
#   Install and configure an instance of Splunk Enterprise
#
# @example Basic usage
#   include splunk::enterprise
#
# @example Install specific version and build with admin passord management
#    class { 'splunk::params':
#      version => '7.2.5',
#      build   => '088f49762779',
#    }
#    class { 'splunk::enterprise':
#      package_ensure => latest,
#      manage_password => true,
#    }
#
# @param version
#   Specifies the version of Splunk Enterprise the module should install and
#   manage.
#
# @param package_name
#   The name of the package(s) Puppet will use to install Splunk.
#
# @param package_ensure
#   Ensure parameter which will get passed to the Splunk package resource.
#
# @param staging_dir
#   Root of the archive path to host the Splunk package.
#
# @param path_delimiter
#   The path separator used in the archived path of the Splunk package.
#
# @param enterprise_package_src
#   The source URL for the splunk installation media (typically an RPM, MSI,
#   etc). If a `$src_root` parameter is set in splunk::params, this will be
#   automatically supplied. Otherwise it is required. The URL can be of any
#   protocol supported by the pupept/archive module. On Windows, this can be
#   a UNC path to the MSI.
#
# @param package_provider
#   The package management system used to host the Splunk packages.
#
# @param manage_package_source
#   Whether or not to use the supplied `enterprise_package_src` param.
#
# @param package_source
#   *Optional* The source URL for the splunk installation media (typically an RPM,
#   MSI, etc). If `enterprise_package_src` parameter is set in splunk::params and
#   `manage_package_source` is true, this will be automatically supplied. Otherwise
#   it is required. The URL can be of any protocol supported by the puppet/archive
#   module. On Windows, this can be a UNC path to the MSI.
#
# @param install_options
#   This variable is passed to the package resources' *install_options* parameter.
#
# @param splunk_user
#   The user to run Splunk as.
#
# @param enterprise_homedir
#   Specifies the Splunk Enterprise home directory.
#
# @param enterprise_confdir
#   Specifies the Splunk Enterprise configuration directory.
#
# @param service_name
#   The name of the Splunk Enterprise service.
#
# @param service_file
#   The path to the Splunk Enterprise service file.
#
# @param boot_start
#   Whether or not to enable splunk boot-start, which generates a service file to
#   manage the Splunk Enterprise service.
#
# @param use_default_config
#   Whether or not the module should manage a default set of Splunk Enterprise
#   configuration parameters.
#
# @param input_default_host
#   Part of the default config. Sets the `splunk_input` default host.
#
# @param input_connection_host
#   Part of the default config. Sets the `splunk_input` connection host.
#
# @param splunkd_listen
#   The address on which splunkd should listen.
#
# @param logging_port
#   The port to receive TCP logs on.
#
# @param splunkd_port
#   The management port for Splunk.
#
# @param web_port
#   The port on which to service the Splunk Web interface.
#
# @param purge_inputs
#   If set to true, inputs.conf will be purged of configuration that is
#   no longer managed by the `splunk_input` type.
#
# @param purge_outputs
#   If set to true, outputs.conf will be purged of configuration that is
#   no longer managed by the `splunk_output` type.
#
# @param purge_authentication
#   If set to true, authentication.conf will be purged of configuration
#   that is no longer managed by the `splunk_authentication` type.
#
# @param purge_authorize
#   If set to true, authorize.conf will be purged of configuration that
#   is no longer managed by the `splunk_authorize` type.
#
# @param purge_distsearch
#   If set to true, distsearch.conf will be purged of configuration that
#   is no longer managed by the `splunk_distsearch` type.
#
# @param purge_indexes
#   If set to true, indexes.conf will be purged of configuration that is
#   no longer managed by the `splunk_indexes` type.
#
# @param purge_limits
#   If set to true, limits.conf will be purged of configuration that is
#   no longer managed by the `splunk_limits` type.
#
# @param purge_props
#   If set to true, props.conf will be purged of configuration that is
#   no longer managed by the `splunk_props` type.
#
# @param purge_server
#   If set to true, server.conf will be purged of configuration that is
#   no longer managed by the `splunk_server` type.
#
# @param purge_transforms
#   If set to true, transforms.conf will be purged of configuration that
#   is no longer managed by the `splunk_transforms` type.
#
# @param purge_web
#   If set to true, web.conf will be purged of configuration that is no
#   longer managed by the `splunk_web type`.
#
# @param manage_password
#   If set to true, Manage the contents of splunk.secret and passwd.
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
# @param password_content
#   The hashed password username/details for the user.
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
class splunk::enterprise (
  String[1] $version                         = $splunk::params::version,
  String[1] $package_name                    = $splunk::params::enterprise_package_name,
  String[1] $package_ensure                  = $splunk::params::enterprise_package_ensure,
  String[1] $staging_dir                     = $splunk::params::staging_dir,
  String[1] $path_delimiter                  = $splunk::params::path_delimiter,
  String[1] $enterprise_package_src          = $splunk::params::enterprise_package_src,
  Optional[String[1]] $package_provider      = $splunk::params::package_provider,
  Boolean $manage_package_source             = true,
  Optional[String[1]] $package_source        = undef,
  Splunk::Entinstalloptions $install_options = $splunk::params::enterprise_install_options,
  String[1] $splunk_user                     = $splunk::params::splunk_user,
  Stdlib::Absolutepath $enterprise_homedir   = $splunk::params::enterprise_homedir,
  Stdlib::Absolutepath $enterprise_confdir   = $splunk::params::enterprise_confdir,
  String[1] $service_name                    = $splunk::params::enterprise_service,
  Stdlib::Absolutepath $service_file         = $splunk::params::enterprise_service_file,
  Boolean $boot_start                        = $splunk::params::boot_start,
  Boolean $use_default_config                = true,
  String[1] $input_default_host              = $facts['fqdn'],
  String[1] $input_connection_host           = 'dns',
  Stdlib::IP::Address $splunkd_listen        = '127.0.0.1',
  Stdlib::Port $splunkd_port                 = $splunk::params::splunkd_port,
  Stdlib::Port $logging_port                 = $splunk::params::logging_port,
  Stdlib::Port $web_httpport                 = 8000,
  Boolean $purge_alert_actions               = false,
  Boolean $purge_authentication              = false,
  Boolean $purge_authorize                   = false,
  Boolean $purge_deploymentclient            = false,
  Boolean $purge_distsearch                  = false,
  Boolean $purge_indexes                     = false,
  Boolean $purge_inputs                      = false,
  Boolean $purge_limits                      = false,
  Boolean $purge_outputs                     = false,
  Boolean $purge_props                       = false,
  Boolean $purge_server                      = false,
  Boolean $purge_serverclass                 = false,
  Boolean $purge_transforms                  = false,
  Boolean $purge_uiprefs                     = false,
  Boolean $purge_web                         = false,
  Boolean $manage_password                   = $splunk::params::manage_password,
  Boolean $seed_password                     = $splunk::params::seed_password,
  Boolean $reset_seeded_password             = $splunk::params::reset_seeded_password,
  Stdlib::Absolutepath $password_config_file = $splunk::params::enterprise_password_config_file,
  Stdlib::Absolutepath $seed_config_file     = $splunk::params::enterprise_seed_config_file,
  String[1] $password_content                = $splunk::params::password_content,
  String[1] $password_hash                   = $splunk::params::password_hash,
  Stdlib::Absolutepath $secret_file          = $splunk::params::enterprise_secret_file,
  String[1] $secret                          = $splunk::params::secret,
) inherits splunk {

  if (defined(Class['splunk::forwarder'])) {
    fail('Splunk Universal Forwarder provides a subset of Splunk Enterprise capabilities, and has potentially conflicting resources when included with Splunk Enterprise on the same node.  Do not include splunk::forwarder on the same node as splunk::enterprise.  Configure Splunk Enterprise to meet your forwarding needs.'
    )
  }

  if ($facts['os']['family'] == 'windows') and ($package_ensure == 'latest') {
    fail('This module does not currently support continuously upgrading Splunk Enterprise on Windows. Please do not set "package_ensure" to "latest" on Windows.')
  }

  if $manage_password and $seed_password {
    fail('The setting "manage_password" and "seed_password" are in conflict with one another; they are two ways of accomplishing the same goal, "seed_password" is preferred according to Splunk documentation. If you need to reset the admin user password after initially installation then set "reset_seeded_password" temporarily.')
  }

  if $manage_password {
    info("The setting \"manage_password\" will manage the contents of ${password_config_file} which Splunk changes on restart, this results in Puppet initiating a corrective change event on every run and will trigger a resart of all Splunk services")
  }

  if $reset_seeded_password {
    info("The setting \"reset_seeded_password\" will delete ${password_config_file} on each run of Puppet and generate a corrective change event, the file must be absent for Splunk's admin password seeding process to be triggered so this setting should only be used temporarily as it'll also cause a resart of the Splunk service")
  }

  contain 'splunk::enterprise::install'
  contain 'splunk::enterprise::config'
  contain 'splunk::enterprise::service'

  Class['splunk::enterprise::install']
  -> Class['splunk::enterprise::config']
  ~> Class['splunk::enterprise::service']

  # Purge resources if option set
  Splunk_config['splunk'] {
    purge_alert_actions    => $purge_alert_actions,
    purge_authentication   => $purge_authentication,
    purge_authorize        => $purge_authorize,
    purge_deploymentclient => $purge_deploymentclient,
    purge_distsearch       => $purge_distsearch,
    purge_indexes          => $purge_indexes,
    purge_inputs           => $purge_inputs,
    purge_limits           => $purge_limits,
    purge_outputs          => $purge_outputs,
    purge_props            => $purge_props,
    purge_server           => $purge_server,
    purge_serverclass      => $purge_serverclass,
    purge_transforms       => $purge_transforms,
    purge_uiprefs          => $purge_uiprefs,
    purge_web              => $purge_web
  }

}
