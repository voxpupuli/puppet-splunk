require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_output) do
  @doc = 'Manage splunk output settings in outputs.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
