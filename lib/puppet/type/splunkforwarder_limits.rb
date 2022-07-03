# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunkforwarder_limits) do
  @doc = 'Manage splunkforwarder limit settings in limits.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
