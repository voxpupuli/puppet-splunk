Puppet::Type.type(:splunkforwarder_output).provide(
  :ini_setting,
  # set ini_setting as the parent provider
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do
  # hard code the file path (this allows purging)
  def self.file_path
    case Facter.value(:osfamily)
    when 'windows'
      'C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf'
    else
      '/opt/splunkforwarder/etc/system/local/outputs.conf'
    end
  end
end
