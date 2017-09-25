Puppet::Type.type(:splunk_deploymentclient).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'deploymentclient.conf'
  end
end
