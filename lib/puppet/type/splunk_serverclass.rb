# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_serverclass) do
  @doc = 'Manage splunk serverclass entries in serverclass.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
