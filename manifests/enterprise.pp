# @summary
#   Install and configure an instance of Splunk Enterprise
#
# @example Basic usage
#   include splunk::enterprise
#
# @example Install specific version and release with admin password management
#    class { 'splunk::enterprise':
#      release => '7.2.5-088f49762779',
#      manage_password => true,
#    }
#
# @param boot_start
#   Whether or not to enable splunk boot-start, which generates a service file to
#   manage the Splunk Enterprise service.
#
# @param confdir
#   Specifies the Splunk Enterprise configuration directory.
#
# @param homedir
#   Specifies the Splunk Enterprise home directory.
#
# @param input_default_host
#   Part of the default config. Sets the `splunk_input` default host.
#
# @param input_connection_host
#   Part of the default config. Sets the `splunk_input` connection host.
#
# @param install_options
#   This variable is passed to the package resources' *install_options* parameter.
#
# @param logging_port
#   The port to receive TCP logs on.
#
# @param manage_package_source
#   Whether or not to use the supplied `managed_package_source` param.
#
# @param manage_password
#   If set to true, Manage the contents of splunk.secret and passwd.
#
# @param package_ensure
#   Optional. Ensure parameter which will get passed to the Splunk package
#   resource.
#
#   It is highly recommended to specify $splunk::enterprise::release to ensure
#   a specific version of the Splunk package.
#
# @param managed_package_source
#   Optional. The source URL for the splunk installation media (typically an
#   RPM, MSI, etc). If a `$src_root` parameter is set in splunk::params, this
#   will be automatically supplied. Otherwise it is required. The URL can be of
#   any protocol supported by the pupept/archive module. On Windows, this can
#   be a UNC path to the MSI.
#
# @param package_name
#   The name of the package(s) Puppet will use to install Splunk.
#
# @param package_provider
#   The package management system used to host the Splunk packages.
#
# @param password_config_file
#   Which file to put the password in i.e. in linux it would be
#   `/opt/splunk/etc/passwd`.
#
# @param password_content
#   The hashed password username/details for the user.
#
# @param password_hash
#   The hashed password for the admin user.
#
# @param path_delimiter
#   The path separator used in the archived path of the Splunk package.
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
# @param release
#   Optional. The release of Splunk to install and configure. It is *highly*
#   recommended you specify a release at all times. 
#
#   It must be in the form `version-release`, eg. 7.2.4.2-fb30470262e3
#
#   If Splunk s not installed before applying the module, you will be required
#   to provide a release.
#
#   Should you not specify a release but Splunk is installed, the
#   splunkenterprise['version'] and splunkenterprise['build'] facts will be
#   used to assume the version of Splunk.
#
# @param reset_seed_password
#   If set to true, deletes `password_config_file` to trigger Splunk's password
#   import process on restart of the Splunk services.
#
# @param secret
#   The secret used to salt the splunk password.
#
# @param secret_file
#   Which file we should put the secret in.
#
# @param seed_config_file
#   Which file to place the admin password hash in so its imported by Splunk on
#   restart.
#
# @param seed_password
#   If set to true, Manage the contents of splunk.secret and user-seed.conf.
#
# @param service_ensure
#   Ensure passed to the splunk service resource.
#
# @param service_file
#   Optional. The path to the Splunk Enterprise service file.
#
# @param service_name
#   Optional. The name of the Splunk Enterprise service.
#
# @param splunk_user
#   The user to run Splunk as.
#
# @param splunkd_listen
#   The address on which splunkd should listen.
#
# @param splunkd_port
#   The management port for Splunk.
#
# @param src_root
#   The root of the splunk package source directory.
#
# @param staging_dir
#   Root of the archive path to host the Splunk package.
#
# @param unmanaged_package_source
#   Optional. The source URL for the splunk installation media (typically an
#   RPM, MSI, etc).
#
#   If `managed_package_source` parameter is set, and `manage_package_source`
#   is true, this will be automatically supplied. Otherwise it is required.
#
#   The URL can be of any protocol supported by the puppet/archive
#   module. On Windows, this can be a UNC path to the MSI.
#
# @param use_default_config
#   Whether or not the module should manage a default set of Splunk Enterprise
#   configuration parameters.
#
# @param web_httpport
#   The port on which to service the Splunk Web interface.
#
class splunk::enterprise (
  Boolean                        $boot_start,
  Stdlib::Absolutepath           $confdir,
  Stdlib::Absolutepath           $homedir,
  String[1]                      $input_default_host,
  String[1]                      $input_connection_host,
  Splunk::Entinstalloptions      $install_options,
  Stdlib::Port                   $logging_port,
  Boolean                        $manage_package_source,
  Boolean                        $manage_password,
  String[1]                      $package_name,
  Optional[String[1]]            $package_provider,
  Stdlib::Absolutepath           $password_config_file,
  String[1]                      $password_content,
  String[1]                      $password_hash,
  String[1]                      $path_delimiter,
  Boolean                        $purge_alert_actions,
  Boolean                        $purge_authentication,
  Boolean                        $purge_authorize,
  Boolean                        $purge_deploymentclient,
  Boolean                        $purge_distsearch,
  Boolean                        $purge_indexes,
  Boolean                        $purge_inputs,
  Boolean                        $purge_limits,
  Boolean                        $purge_outputs,
  Boolean                        $purge_props,
  Boolean                        $purge_server,
  Boolean                        $purge_serverclass,
  Boolean                        $purge_transforms,
  Boolean                        $purge_uiprefs,
  Boolean                        $purge_web,
  Boolean                        $reset_seeded_password,
  String[1]                      $secret,
  Stdlib::Absolutepath           $secret_file,
  Stdlib::Absolutepath           $seed_config_file,
  Boolean                        $seed_password,
  String[1]                      $service_ensure,
  String[1]                      $splunk_user,
  Stdlib::IP::Address            $splunkd_listen,
  Stdlib::Port                   $splunkd_port,
  String[1]                      $src_root,
  String[1]                      $src_subdir,
  String[1]                      $staging_dir,
  Boolean                        $use_default_config,
  Stdlib::Port                   $web_httpport,
  Optional[String[1]]            $managed_package_source   = undef,
  Optional[String[1]]            $package_ensure           = undef,
  Optional[Splunk::Release]      $release                  = undef,
  Optional[String[1]]            $service_name             = undef,
  Optional[Stdlib::Absolutepath] $service_file             = undef,
  Optional[String[1]]            $unmanaged_package_source = undef,
) {

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

  # Determine the Splunk version to ensure
  if $release {
    $_version = split($release,'-')[0]
    $_build = split($release,'-')[1]

    if $package_ensure and $package_ensure =~ /^\d/ {
      warning("Setting `splunk::enterprise::package_ensure` and `splunk::enterprise::release` to specific versions could result in unwanted behavior.  It is recommended you specify the splunk version with `splunk::enterprise::release` only, in the form `version-build`, eg. 7.2.4.2-fb30470262e3'")
    }
  }
  elsif has_key($facts['splunkenterprise'],'version') and has_key($facts['splunkenterprise'],'build') {
    $_version = $facts['splunkenterprise']['version']
    $_build = $facts['splunkenterprise']['build']
  }
  else {
    fail('No splunk version detected (installed), you need to specify `$splunk::enterprise::release` in the form `version-build`, eg. 7.2.4.2-fb30470262e3')
  }

  # Determine the Splunk service name and service file path
  case $facts['kernel'] {
    /^(Linux|SunOS)$/ : {
      if $facts['service_provider'] == 'systemd' and versioncmp($_version, '7.2.2') >= 0 {
        $_splunk_service_name = 'Splunkd'
        $_splunk_service_file = '/etc/systemd/system/multi-user.target.wants/Splunkd.service'
      }
      else {
        $_splunk_service_name = 'splunk'
        $_splunk_service_file = '/etc/init.d/splunk'
      }
    }
    'windows': {
      $_splunk_service_name = 'splunkd'
      $_splunk_service_file = "${homedir}\\dummy"
    }
    default  : { fail("splunk module does not support kernel ${facts['kernel']}") }
  }
  $_service_name = pick($service_name, $_splunk_service_name)
  $_service_file = pick($service_file, $_splunk_service_file)


  contain 'splunk::enterprise::install'
  contain 'splunk::enterprise::config'
  contain 'splunk::enterprise::service'

  Class['splunk::enterprise::install']
  -> Class['splunk::enterprise::config']
  ~> Class['splunk::enterprise::service']

  # A meta resource so providers know where splunk is installed:
  splunk_config { 'splunk':
    server_installdir      => $homedir,
    server_confdir         => $confdir,
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
    purge_web              => $purge_web,
  }
}
