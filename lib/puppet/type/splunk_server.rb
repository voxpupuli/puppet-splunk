# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_server) do
  @doc = 'Manage splunk server settings in server.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
