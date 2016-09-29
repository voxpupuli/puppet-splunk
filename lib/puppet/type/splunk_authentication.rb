require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_authentication) do
  @doc = 'Manage splunk authentication settings in authentication.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
