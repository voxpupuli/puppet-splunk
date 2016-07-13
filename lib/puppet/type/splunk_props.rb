require 'puppet_x/puppetlabs/splunk/type'

Puppet::Type.newtype(:splunk_props) do
  @doc = "Manage splunk prop settings in props.conf"
  PuppetX::Puppetlabs::Splunk::Type.clone(self)
end
