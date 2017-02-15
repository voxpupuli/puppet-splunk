require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_alert_actions) do
  @doc = 'Manage splunk alert_actions settings in alert_actions.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
