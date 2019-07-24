require 'spec_helper'

describe 'splunk::addon' do
  context 'fail if class prerequisit not declared' do
    on_supported_os.each do |os, facts|
      if os.start_with?('windows')
        # Splunk Server not used supported on windows
      else
        context "on #{os}" do
          let(:facts) do
            facts
          end
          let(:title) { 'Splunk_TA' }
          let(:params) { { 'splunkbase_source' => 'puppet:///modules/profiles/splunk-add-on.tgz' } }

          it { is_expected.to raise_error(Puppet::Error) }
        end
      end
    end
  end

  context 'supported operating systems' do
    let(:pre_condition) do
      "class { 'splunk::forwarder': release => '7.2.4.2-abcdefg', }"
    end

    on_supported_os.each do |os, facts|
      if os.start_with?('windows')
        # Splunk Server not used supported on windows
      else
        context "on #{os}" do
          let(:facts) do
            facts
          end
          let(:title) { 'Splunk_TA' }
          let(:params) { { 'splunkbase_source' => 'puppet:///modules/profiles/splunk-add-on.tgz' } }

          it { is_expected.to compile.with_all_deps }
        end
      end
    end
  end
end
