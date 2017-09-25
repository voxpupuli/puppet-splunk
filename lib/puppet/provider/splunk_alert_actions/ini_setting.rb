Puppet::Type.type(:splunk_alert_actions).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk)
) do
  def self.file_name
    'alert_actions.conf'
  end
end
