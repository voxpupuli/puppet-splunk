Puppet::Type.type(:splunk_authentication).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'system/local/authentication.conf'
  end
end
