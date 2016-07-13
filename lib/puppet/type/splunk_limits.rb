require 'puppet_x/puppetlabs/splunk/type'

Puppet::Type.newtype(:splunk_limits) do
  @doc = "Manage splunk limits settings in limits.conf"
  PuppetX::Puppetlabs::Splunk::Type.clone(self)
end
