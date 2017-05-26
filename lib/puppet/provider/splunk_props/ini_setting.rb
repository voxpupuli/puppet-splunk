Puppet::Type.type(:splunk_props).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'props.conf'
  end
end
