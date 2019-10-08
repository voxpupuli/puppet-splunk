Facter.add(:splunkforwarder) do
  setcode do
    splunkforwarder_hash = {}
    cmd = if File.exist?('C:/Program Files/SplunkUniversalForwarder/bin/splunk.exe')
            '"C:/Program Files/SplunkUniversalForwarder/bin/splunk.exe" --version'
          elsif File.exist?('/opt/splunkforwarder/bin/splunk')
            '/opt/splunkforwarder/bin/splunk --version'
          end
    if cmd
      output = Facter::Util::Resolution.exec(cmd)
      if output =~ %r{^Splunk Universal Forwarder ([0-9\.]+) \(build\s*(.*)\)}
        splunkforwarder_hash['version'] = Regexp.last_match(1)
        splunkforwarder_hash['build'] = Regexp.last_match(2)
      end
    end
    splunkforwarder_hash
  end
end
