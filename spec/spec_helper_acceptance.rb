require 'voxpupuli/acceptance/spec_helper_acceptance'
require 'splunk_data.rb'

configure_beaker do |host|
  # Need to stage the Splunk/Splunkforwarder packages here.

  # The splunk unit file assumes certain cgroups are present, which is not
  # the case in the testing container(s).  Create cgroups resources here.
  on(host, '/bin/mkdir -p /sys/fs/cgroup/cpu/system.slice/Splunkd.service')
  on(host, '/bin/mkdir -p /sys/fs/cgroup/memory/system.slice/Splunkd.service')
  on(host, '/bin/mkdir -p /sys/fs/cgroup/cpu/system.slice/SplunkForwarder.service')
  on(host, '/bin/mkdir -p /sys/fs/cgroup/memory/system.slice/SplunkForwarder.service')
end
