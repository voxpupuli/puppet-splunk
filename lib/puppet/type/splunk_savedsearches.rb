require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_savedsearches) do
  @doc = 'Manage splunk settings in savedsearches.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
