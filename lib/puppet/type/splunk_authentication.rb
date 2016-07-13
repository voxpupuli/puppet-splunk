require 'puppet_x/puppetlabs/splunk/type'

Puppet::Type.newtype(:splunk_authentication) do
  @doc = "Manage splunk authentication settings in authentication.conf"
  PuppetX::Puppetlabs::Splunk::Type.clone(self)
end

