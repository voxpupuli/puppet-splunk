require 'puppet_x/puppetlabs/splunk/type'

Puppet::Type.newtype(:splunk_distsearch) do
  @doc= "Manage distsearch entries in distsearch.conf"
  PuppetX::Puppetlabs::Splunk::Type.clone(self)
end
