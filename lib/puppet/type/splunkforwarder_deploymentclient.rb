# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunkforwarder_deploymentclient) do
  @doc = 'Manage splunkforwarder deploymentclient entries in deploymentclient.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
