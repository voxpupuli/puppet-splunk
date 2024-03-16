# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_web) do
  @doc = 'Manage splunk web settings in web.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
