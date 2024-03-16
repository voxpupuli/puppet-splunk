# frozen_string_literal: true

Puppet::Type.type(:splunk_web).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'web.conf'
  end
end
