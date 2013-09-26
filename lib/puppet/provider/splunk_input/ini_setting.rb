Puppet::Type.type(:splunk_input).provide(
  :ini_setting,
  # set ini_setting as the parent provider
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do
  # hard code the file path (this allows purging)
  def self.file_path
    case Facter.value(:osfamily)
    when 'windows'
      'C:\Program Files\Splunk\etc\system\local\inputs.conf'
    else
      '/opt/splunk/etc/system/local/inputs.conf'
    end
  end
end
