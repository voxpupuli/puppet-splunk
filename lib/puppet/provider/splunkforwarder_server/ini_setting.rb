Puppet::Type.type(:splunkforwarder_server).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'server.conf'
  end
end
