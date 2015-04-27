require 'spec_helper_acceptance'
require 'pry'

pp = <<-EOS
  class { 'splunk::params':
    version     => '6.2.2',
    build       => '255606',
  }
  class { 'splunk':
    splunkd_listen => '0.0.0.0',
  }

  splunk_transforms { 'hadoop severity regex':
    section => 'hadoop_severity',
    setting => 'REGEX',
    value   => '\\d',
    require => Service[splunk]
  }
  splunk_transforms { 'hadoop severity format':
    section => 'hadoop_severity',
    setting => 'FORMAT',
    value   => 'severity::$1',
    require => Service[splunk]
  }
EOS

describe 'setting up the server' do
  it 'should be able to set up a server' do
    apply_manifest(pp, catch_failures: true)
  end

  it 'should apply the manifest again and make no further changes' do
    apply_manifest(pp, catch_changes: true)
  end

  describe service('splunk') do
    it { should be_running }
  end

  describe port(9997) do
    it { should be_listening.on('0.0.0.0').with('tcp') }
  end

  describe port(8089) do
    it { should be_listening.on('0.0.0.0').with('tcp') }
  end

  describe port(8000) do
    it { should be_listening.on('0.0.0.0').with('tcp') }
  end

  describe file('/opt/splunk/etc/system/local/transforms.conf') do
    its(:content) { should match(/\[hadoop_severity\]\nFORMAT=severity::\$1\nREGEX=\\d/) }
  end
end
