# frozen_string_literal: true

Puppet::Type.type(:splunkforwarder_deploymentclient).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'deploymentclient.conf'
  end
end
