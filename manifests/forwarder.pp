# @summary
#   Install and configure an instance of Splunk Universal Forwarder
#
# @example Basic usage
#   include splunk::forwarder
#
# @example Install specific version and build with admin passord management
#    class { 'splunk::params':
#      version => '7.2.5',
#      build   => '088f49762779',
#    }
#    class { 'splunk::forwarder':
#      package_ensure => latest,
#      manage_password => true,
#    }
#
# @param server
#   The fqdn or IP address of the Splunk server.
#
# @param version`
#   Specifies the version of Splunk Forwarder the module should install and
#   manage.
#
# @param package_name
#   The name of the package(s) Puppet will use to install Splunk Forwarder.
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
# @param forwarder_package_src
#   The source URL for the splunk installation media (typically an RPM, MSI,
#   etc). If a `$src_root` parameter is set in splunk::params, this will be
#   automatically supplied. Otherwise it is required. The URL can be of any
#   protocol supported by the puppet/archive module. On Windows, this can be
#   a UNC path to the MSI.
#
# @param package_provider
#   The package management system used to host the Splunk packages.
#
# @param manage_package_source
#   Whether or not to use the supplied `forwarder_package_src` param.
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
# @param forwarder_homedir
#   Specifies the Splunk Forwarder home directory.
#
# @param forwarder_confdir
#   Specifies the Splunk Forwarder configuration directory.
#
# @param service_name
#   The name of the Splunk Forwarder service.
#
# @param service_file
#   The path to the Splunk Forwarder service file.
#
# @param boot_start
#   Whether or not to enable splunk boot-start, which generates a service file to
#   manage the Splunk Forwarder service.
#
# @param use_default_config
#   Whether or not the module should manage a default set of Splunk Forwarder
#   configuration parameters.
#
# @param splunkd_listen
#   The address on which splunkd should listen.
#
# @param splunkd_port
#   The management port for Splunk.
#
# @param logging_port
#   The port on which to send and listen for logs.
#
# @param purge_inputs
#   *Optional* If set to true, inputs.conf will be purged of configuration that is
#   no longer managed by the `splunkforwarder_input` type.
#
# @param purge_outputs
#   *Optional* If set to true, outputs.conf will be purged of configuration that is
#   no longer managed by the `splunk_output` type.
#
# @param purge_props
#   *Optional* If set to true, props.conf will be purged of configuration that is
#   no longer managed by the `splunk_props` type.
#
# @param purge_transforms
#   *Optional* If set to true, transforms.conf will be purged of configuration that is
#   no longer managed by the `splunk_transforms` type.
#
# @param purge_web
#   *Optional* If set to true, web.conf will be purged of configuration that is
#   no longer managed by the `splunk_web` type.
#
# @param forwarder_input
#   Used to override the default `forwarder_input` type defined in splunk::params.
#
# @param forwarder_output
#   Used to override the default `forwarder_output` type defined in splunk::params.
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
#   `/opt/splunkforwarder/etc/passwd`.
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
# @param addons
#   Manage a splunk addons, see `splunk::addons`.
#
class splunk::forwarder(
  String[1] $server                          = $splunk::params::server,
  String[1] $version                         = $splunk::params::version,
  String[1] $package_name                    = $splunk::params::forwarder_package_name,
  String[1] $package_ensure                  = $splunk::params::forwarder_package_ensure,
  String[1] $staging_dir                     = $splunk::params::staging_dir,
  String[1] $path_delimiter                  = $splunk::params::path_delimiter,
  String[1] $forwarder_package_src           = $splunk::params::forwarder_package_src,
  Optional[String[1]] $package_provider      = $splunk::params::package_provider,
  Boolean $manage_package_source             = true,
  Optional[String[1]] $package_source        = undef,
  Splunk::Fwdinstalloptions $install_options = $splunk::params::forwarder_install_options,
  String[1] $splunk_user                     = $splunk::params::splunk_user,
  Stdlib::Absolutepath $forwarder_homedir    = $splunk::params::forwarder_homedir,
  Stdlib::Absolutepath $forwarder_confdir    = $splunk::params::forwarder_confdir,
  String[1] $service_name                    = $splunk::params::forwarder_service,
  Stdlib::Absolutepath $service_file         = $splunk::params::forwarder_service_file,
  Boolean $boot_start                        = $splunk::params::boot_start,
  Boolean $use_default_config                = true,
  Stdlib::IP::Address $splunkd_listen        = '127.0.0.1',
  Stdlib::Port $splunkd_port                 = $splunk::params::splunkd_port,
  Stdlib::Port $logging_port                 = $splunk::params::logging_port,
  Boolean $purge_deploymentclient            = false,
  Boolean $purge_outputs                     = false,
  Boolean $purge_inputs                      = false,
  Boolean $purge_props                       = false,
  Boolean $purge_transforms                  = false,
  Boolean $purge_web                         = false,
  Hash $forwarder_output                     = $splunk::params::forwarder_output,
  Hash $forwarder_input                      = $splunk::params::forwarder_input,
  Boolean $manage_password                   = $splunk::params::manage_password,
  Boolean $seed_password                     = $splunk::params::seed_password,
  Boolean $reset_seeded_password             = $splunk::params::reset_seeded_password,
  Stdlib::Absolutepath $password_config_file = $splunk::params::forwarder_password_config_file,
  Stdlib::Absolutepath $seed_config_file     = $splunk::params::forwarder_seed_config_file,
  String[1] $password_content                = $splunk::params::password_content,
  String[1] $password_hash                   = $splunk::params::password_hash,
  Stdlib::Absolutepath $secret_file          = $splunk::params::forwarder_secret_file,
  String[1] $secret                          = $splunk::params::secret,
  Hash $addons                               = {},
) inherits splunk {

  if (defined(Class['splunk::enterprise'])) {
    fail('Splunk Universal Forwarder provides a subset of Splunk Enterprise capabilities, and has potentially conflicting resources when included with Splunk Enterprise on the same node.  Do not include splunk::forwarder on the same node as splunk::enterprise.  Configure Splunk Enterprise to meet your forwarding needs.'
    )
  }

  if ($facts['os']['family'] == 'windows') and ($package_ensure == 'latest') {
    fail('This module does not currently support continuously upgrading the Splunk Universal Forwarder on Windows. Please do not set "package_ensure" to "latest" on Windows.')
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

  contain 'splunk::forwarder::install'
  contain 'splunk::forwarder::config'
  contain 'splunk::forwarder::service'

  Class['splunk::forwarder::install']
  -> Class['splunk::forwarder::config']
  ~> Class['splunk::forwarder::service']

  Splunk_config['splunk'] {
    forwarder_confdir                => $forwarder_confdir,
    purge_forwarder_deploymentclient => $purge_deploymentclient,
    purge_forwarder_outputs          => $purge_outputs,
    purge_forwarder_inputs           => $purge_inputs,
    purge_forwarder_props            => $purge_props,
    purge_forwarder_transforms       => $purge_transforms,
    purge_forwarder_web              => $purge_web,
  }

}
