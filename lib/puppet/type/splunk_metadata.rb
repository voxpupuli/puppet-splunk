require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_metadata) do
  @doc = 'Manage metadata entries in {default,local}.meta'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
