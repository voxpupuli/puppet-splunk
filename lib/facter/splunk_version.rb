Facter.add(:splunk_version) do
  setcode do
    value = nil
    kernel = Facter.value(:kernel)
    version_file = case kernel
                   when 'Linux'
                     '/opt/splunk/etc/splunk.version'
                   when 'windows'
                     'C:/Program Files/Splunk/etc/splunk.version'
                   end

    if File.exist?(version_file)
      splunk_version = File.open(version_file).read
      value = Regexp.last_match(1) if splunk_version =~ %r{^VERSION=([0-9.]+)}
    end
    value
  end
end
