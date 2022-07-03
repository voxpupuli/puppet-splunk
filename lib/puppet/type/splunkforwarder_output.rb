# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunkforwarder_output) do
  @doc = 'Manage splunkforwarder output settings in outputs.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
