require 'puppet_x/puppetlabs/splunk/type'

Puppet::Type.newtype(:splunkforwarder_props) do
  @doc = "Manage splunkforwarder props settings in props.conf"
  PuppetX::Puppetlabs::Splunk::Type.clone(self)
end
