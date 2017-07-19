require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunkforwarder_server) do
  @doc = 'Manage splunkforwarder server settings in server.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
