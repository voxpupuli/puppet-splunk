Puppet::Type.type(:splunkforwarder_limits).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'limits.conf'
  end
end
