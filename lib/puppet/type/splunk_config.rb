# Require all of our types so the class names are resolvable for purging
Dir[File.dirname(__FILE__) + '/splunk*.rb'].each do |file|
  require file unless file == __FILE__
end

Puppet::Type.newtype(:splunk_config) do
  newparam(:name, namevar: true) do
    desc 'splunk config'
  end

  newparam(:forwarder_installdir) do
  end

  newparam(:forwarder_confdir) do
  end

  newparam(:server_installdir) do
  end

  newparam(:server_confdir) do
  end

  ## Generate purge parameters for the splunk_config type
  [
    :purge_inputs,
    :purge_outputs,
    :purge_alert_actions,
    :purge_authentication,
    :purge_authorize,
    :purge_deploymentclient,
    :purge_distsearch,
    :purge_indexes,
    :purge_limits,
    :purge_metadata,
    :purge_props,
    :purge_server,
    :purge_serverclass,
    :purge_transforms,
    :purge_web,
    :purge_uiprefs,
    :purge_forwarder_deploymentclient,
    :purge_forwarder_inputs,
    :purge_forwarder_outputs,
    :purge_forwarder_props,
    :purge_forwarder_transforms,
    :purge_forwarder_web,
    :purge_forwarder_server
  ].each do |p|
    newparam(p) do
      newvalues(:true, :false)
      defaultto :false
    end
  end

  # The generate method sets the correct paths for the providers
  # and spawns any resources that need purging.
  #
  def generate
    set_provider_paths

    resources = []

    {
      Puppet::Type::Splunk_alert_actions             => self[:purge_alert_actions],
      Puppet::Type::Splunk_output                    => self[:purge_outputs],
      Puppet::Type::Splunk_input                     => self[:purge_inputs],
      Puppet::Type::Splunk_authentication            => self[:purge_authentication],
      Puppet::Type::Splunk_authorize                 => self[:purge_authorize],
      Puppet::Type::Splunk_deploymentclient          => self[:purge_deploymentclient],
      Puppet::Type::Splunk_distsearch                => self[:purge_distsearch],
      Puppet::Type::Splunk_indexes                   => self[:purge_indexes],
      Puppet::Type::Splunk_metadata                  => self[:purge_metadata],
      Puppet::Type::Splunk_props                     => self[:purge_props],
      Puppet::Type::Splunk_server                    => self[:purge_server],
      Puppet::Type::Splunk_serverclass               => self[:purge_serverclass],
      Puppet::Type::Splunk_transforms                => self[:purge_transforms],
      Puppet::Type::Splunk_web                       => self[:purge_web],
      Puppet::Type::Splunk_uiprefs                   => self[:purge_uiprefs],
      Puppet::Type::Splunkforwarder_deploymentclient => self[:purge_forwarder_deploymentclient],
      Puppet::Type::Splunkforwarder_input            => self[:purge_forwarder_inputs],
      Puppet::Type::Splunkforwarder_output           => self[:purge_forwarder_outputs],
      Puppet::Type::Splunkforwarder_props            => self[:purge_forwarder_props],
      Puppet::Type::Splunkforwarder_transforms       => self[:purge_forwarder_transforms],
      Puppet::Type::Splunkforwarder_web              => self[:purge_forwarder_web],
      Puppet::Type::Splunkforwarder_server           => self[:purge_forwarder_server]
    }.each do |k, purge|
      resources.concat(purge_splunk_resources(k)) if purge == :true
    end

    resources
  end

  def set_provider_paths
    [
      :splunk_alert_actions,
      :splunk_authentication,
      :splunk_authorize,
      :splunk_deploymentclient,
      :splunk_distsearch,
      :splunk_indexes,
      :splunk_limits,
      :splunk_input,
      :splunk_output,
      :splunk_metadata,
      :splunk_props,
      :splunk_server,
      :splunk_serverclass,
      :splunk_transforms,
      :splunk_web,
      :splunk_uiprefs
    ].each do |res_type|
      provider_class = Puppet::Type.type(res_type).provider(:ini_setting)
      provider_class.file_path = self[:server_confdir]
    end
    [
      :splunkforwarder_deploymentclient,
      :splunkforwarder_input,
      :splunkforwarder_output,
      :splunkforwarder_props,
      :splunkforwarder_transforms,
      :splunkforwarder_web,
      :splunkforwarder_server,
      :splunkforwarder_limits
    ].each do |res_type|
      provider_class = Puppet::Type.type(res_type).provider(:ini_setting)
      provider_class.file_path = self[:forwarder_confdir]
    end
  end

  # Returns an array of contexts we want to consider when looking for
  # resources of a particular type to purge
  def contexts(type_class)
    contexts = ['system/local'] # Always consider the default context
    catalog_resources = catalog.resources.select { |r| r.is_a?(type_class) }
    catalog_resources.each do |res|
      contexts << res[:context]
    end
    contexts.uniq
  end

  def purge_splunk_resources(type_class)
    contexts(type_class).map do |context|
      purge_splunk_resources_in_context(type_class, context)
    end.flatten
  end

  def purge_splunk_resources_in_context(type_class, context)
    type_name = type_class.name
    purge_resources = []
    puppet_resources = []

    # Search the catalog for resource types matching the provided class
    # type and context.  Then build an array of puppet resources matching
    # the namevar as section/setting
    #
    catalog_resources = catalog.resources.select { |r| r.is_a?(type_class) && r[:context] == context }
    Puppet.debug "Found #{catalog_resources.size} #{type_class} resources in context #{context}"
    catalog_resources.each do |res|
      puppet_resources << res[:section] + '/' + res[:setting]
    end

    # Search the configured instances of the class type and purge them if
    # the instance name (setion/setting) isn't found in puppet_resources
    #

    # ini_setting's `instances` method will only work if the provider is
    # configured with the complete file_path (including `context`).
    # Temporarily update it before calling `instances`
    #
    provider = Puppet::Type.type(type_name).provider(:ini_setting)

    save_file_path = provider.file_path
    provider.file_path = File.join(save_file_path, context, provider.file_name)
    instances = Puppet::Type.type(type_name).instances

    # Restore the provider's original file_path
    provider.file_path = save_file_path

    instances.each do |instance|
      next if puppet_resources.include?(instance.name)
      purge_resources << Puppet::Type.type(type_name).new(
        name: "Purge #{context} #{instance.name}",
        section: instance[:section],
        setting: instance[:setting],
        context: context,
        ensure: :absent
      )
    end

    purge_resources
  end
end
