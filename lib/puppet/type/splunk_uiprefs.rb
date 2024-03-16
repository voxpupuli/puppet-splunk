# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '..', '..', 'puppet_x/puppetlabs/splunk/type')

Puppet::Type.newtype(:splunk_uiprefs) do
  @doc = 'Manage splunk web ui settings in ui-prefs.conf'
  PuppetX::Puppetlabs::Splunk::Type.clone_type(self)
end
