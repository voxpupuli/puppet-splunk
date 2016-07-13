require 'puppet_x/puppetlabs/splunk/type'

Puppet::Type.newtype(:splunk_authorize) do
  @doc = "Manage splunk authorize settings in authorize.conf"
  PuppetX::Puppetlabs::Splunk::Type.clone(self)
end
