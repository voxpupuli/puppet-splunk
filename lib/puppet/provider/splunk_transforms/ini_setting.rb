# frozen_string_literal: true

Puppet::Type.type(:splunk_transforms).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'transforms.conf'
  end
end
