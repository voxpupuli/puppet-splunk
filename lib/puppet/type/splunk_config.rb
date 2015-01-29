Puppet::Type.newtype(:splunk_config) do
  newparam(:name, :namevar => true) do
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
end
