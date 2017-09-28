Puppet::Type.type(:splunk_serverclass).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'serverclass.conf'
  end
end
