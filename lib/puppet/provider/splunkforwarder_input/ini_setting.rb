# frozen_string_literal: true

Puppet::Type.type(:splunkforwarder_input).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'inputs.conf'
  end
end
