require 'spec_helper_acceptance'
require 'pry'

pp = <<-EOS
  class { 'splunk::params':
    version => '6.2.2',
    build   => '255606',
  }
  class { 'splunk::forwarder': }

  splunkforwarder_transforms { 'hadoop severity regex':
    section => 'hadoop_severity',
    setting => 'REGEX',
    value   => '\\d',
    require => Service[splunk]
  }
  splunkforwarder_transforms { 'hadoop severity format':
    section => 'hadoop_severity',
    setting => 'FORMAT',
    value   => 'severity::$1',
    require => Service[splunk]
  }
EOS

describe 'setting up the forwarder' do
  it 'should be able to set up a forwarder' do
    apply_manifest(pp, catch_failures: true)
  end

  it 'should apply the manifest again and make no further changes' do
    apply_manifest(pp, catch_changes: true)
  end

  describe service('splunk') do
    it { should be_running }
  end

  describe file('/opt/splunkforwarder/etc/system/local/transforms.conf') do
    its(:content) { should match(/\[hadoop_severity\]\nREGEX=\\d\nFORMAT=severity/) }
  end
end
