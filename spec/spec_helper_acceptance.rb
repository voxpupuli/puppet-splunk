require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'
require 'splunk_data.rb'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_module
install_module_dependencies

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Need to stage the Splunk/Splunkforwarder packages here.

    # The splunk unit file assumes certain cgroups are present, which is not
    # the case in the testing container(s).  Create cgroups resources here.
    hosts.each do |host|
      on(host, '/bin/mkdir -p /sys/fs/cgroup/cpu/system.slice/Splunkd.service')
      on(host, '/bin/mkdir -p /sys/fs/cgroup/memory/system.slice/Splunkd.service')
      on(host, '/bin/mkdir -p /sys/fs/cgroup/cpu/system.slice/SplunkForwarder.service')
      on(host, '/bin/mkdir -p /sys/fs/cgroup/memory/system.slice/SplunkForwarder.service')
    end
  end
end
