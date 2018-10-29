Facter.add(:splunk_version) do
  setcode do
    value = nil
    cmd = if File.exist?('C:/Program Files/Splunk/bin/splunk.exe')
            '"C:/Program Files/Splunk/bin/splunk.exe" --version'
          elsif File.exist?('/opt/splunk/bin/splunk')
            '/opt/splunk/bin/splunk --version'
          end
    if cmd
      output = Facter::Util::Resolution.exec(cmd)
      if output =~ %r{^Splunk ([0-9\.]+) \(} # rubocop:disable Style/IfUnlessModifier
        value = Regexp.last_match(1)
      end
    end
    value
  end
end
