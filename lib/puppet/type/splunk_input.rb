require 'puppet_x/puppetlabs/splunk/type'

Puppet::Type.newtype(:splunk_input) do
  @doc = "Manage splunk input settings in inputs.conf"
  PuppetX::Puppetlabs::Splunk::Type.clone(self)
end
