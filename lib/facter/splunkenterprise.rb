Facter.add(:splunkenterprise) do
  setcode do
    splunk_hash = {}
    cmd = if File.exist?('C:/Program Files/Splunk/bin/splunk.exe')
            '"C:/Program Files/Splunk/bin/splunk.exe" --version'
          elsif File.exist?('/opt/splunk/bin/splunk')
            '/opt/splunk/bin/splunk --version'
          end
    if cmd
      output = Facter::Util::Resolution.exec(cmd)
      if output =~ %r{^Splunk ([0-9\.]+) \(build\s*(.*)\)}
        splunk_hash['version'] = Regexp.last_match(1)
        splunk_hash['build'] = Regexp.last_match(2)
      end
    end
    splunk_hash
  end
end
