Puppet::Type.type(:splunk_output).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'system/local/outputs.conf'
  end
end
