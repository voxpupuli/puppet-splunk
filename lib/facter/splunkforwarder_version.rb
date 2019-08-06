Facter.add(:splunkforwarder_version) do
  setcode do
    value = nil
    kernel = Facter.value(:kernel)
    case kernel
    when 'Linux'
      version_file = '/opt/splunkforwarder/etc/splunk.version'
    when 'windows'
      version_file = 'C:/Program Files/SplunkUniversalForwarder/etc/splunk.version'
    end

    if File.exist?(version_file)
      splunk_version = open(version_file).read
      if (splunk_version =~ /^VERSION=([0-9\.]+)/)
        value = Regexp.last_match(1)
      end
    end
    value
  end
end
