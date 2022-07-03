# frozen_string_literal: true

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

          it { is_expected.to compile.and_raise_error(%r{Error while evaluating a Function Call}) }
        end
      end
    end
  end

  context 'supported operating systems' do
    let(:pre_condition) do
      'include splunk::forwarder'
    end

    on_supported_os.each do |os, facts|
      if os.start_with?('windows')
        # Splunk Server not used supported on windows
      else
        context "on #{os}" do
          let(:facts) do
            facts
          end

          context 'basic addon' do
            let(:title) { 'Splunk_TA' }
            let(:params) { { 'splunkbase_source' => 'puppet:///modules/profiles/splunk-add-on.tgz' } }

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_archive('Splunk_TA').with(source: 'puppet:///modules/profiles/splunk-add-on.tgz') }
          end

          context 'addon requiring extract_command' do
            let(:title) { 'Splunk_TA' }
            let(:params) do
              { 'splunkbase_source' => 'puppet:///modules/profiles/splunk-add-on.spl',
                'extract_command' => 'tar zxf %s' }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_archive('Splunk_TA').with(source: 'puppet:///modules/profiles/splunk-add-on.spl', extract_command: 'tar zxf %s') }
          end
        end
      end
    end
  end
end
