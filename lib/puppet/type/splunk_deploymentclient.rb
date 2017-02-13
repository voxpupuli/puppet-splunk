require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_deploymentclient) do
  @doc = 'Manage splunk deploymentclient entries in deploymentclient.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
