Facter.add(:splunkforwarder_version) do
  setcode do
    value = nil
    cmd = if File.exist?('C:/Program Files/SplunkUniversalForwarder/bin/splunk.exe')
            '"C:/Program Files/SplunkUniversalForwarder/bin/splunk.exe" --version'
          elsif File.exist?('/opt/splunkforwarder/bin/splunk')
            '/opt/splunkforwarder/bin/splunk --version'
          end
    if cmd
      output = Facter::Util::Resolution.exec(cmd)
      if output =~ %r{^Splunk Universal Forwarder ([0-9\.]+) \(}
        value = Regexp.last_match(1)
      end
    end
    value
  end
end
