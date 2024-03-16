# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_indexes) do
  @doc = 'Manage splunk index settings in indexes.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
