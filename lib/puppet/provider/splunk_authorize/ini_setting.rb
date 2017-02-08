Puppet::Type.type(:splunk_authorize).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'authorize.conf'
  end
end
