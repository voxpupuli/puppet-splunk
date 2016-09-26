require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunkforwarder_web) do
  @doc = 'Manage splunkforwarder web settings in web.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
