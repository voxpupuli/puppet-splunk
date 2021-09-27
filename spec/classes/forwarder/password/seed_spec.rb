# frozen_string_literal: true

require 'spec_helper'

describe 'splunk::forwarder::password::seed' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        if os.start_with?('windows')
          # Splunk Server not used supported on windows
        else

          context 'when passed no parameters' do
            let(:facts) { facts }

            it { is_expected.to compile.with_all_deps }
          end

          context 'managing a secret file' do
            let(:facts) { facts }
            let(:params) do
              { 'secret_file' => '/some/secretfilepath',
                'splunk_user' => 'someuser',
                'secret'      => 'hunter2', }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file('/some/secretfilepath').with(ensure: 'file', owner: 'someuser', group: 'someuser', content: 'hunter2') }
            # That owner/group thing is kinda awful.  Someone who cares should fix that.
          end

          context 'do not maintain seed_config_file if we are not resetting' do
            # splunkforwarder_version fact means we installed previously
            let(:facts) do
              facts.merge({ 'splunkforwarder_version' => '1.2.3' })
            end
            let(:params) do
              { 'seed_config_file'      => '/some/seedfile1',
                'reset_seeded_password' => false, }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.not_to contain_file('/some/seedfile1') }
          end

          context 'do maintain seed_config_file if we are told to reset' do
            let(:facts) do
              facts.merge({ 'splunkforwarder_version' => '1.2.3' })
            end
            let(:params) do
              { 'reset_seeded_password' => true,
                'password_config_file'  => '/some/conffile',
                'seed_config_file'      => '/some/seedfile',
                'seed_user'             => 'adminuser',
                'password_hash'         => 'abcdefghijklmnop',
                'splunk_user'           => 'someuser',
                'service'               => 'theforwarderservice',
                'mode'                  => 'agent', }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file('/some/conffile').with(ensure: 'absent') }
            it { is_expected.to contain_file('/some/seedfile').with(ensure: 'file', owner: 'someuser', group: 'someuser') }
            it { is_expected.to contain_file('/some/seedfile').with_content(%r{USERNAME=adminuser}) }
            it { is_expected.to contain_file('/some/seedfile').with_content(%r{HASHED_PASSWORD=abcdefghijklmnop}) }
            it { is_expected.not_to contain_service('theforwarderservice') }
          end

          context 'do maintain seed_config_file if we are installing via agent' do
            # no splunkforwarder_version fact and reset_seeded_password=false is 'installing'
            let(:facts) { facts }
            let(:params) do
              { 'reset_seeded_password' => false,
                'password_config_file'  => '/some/conffile',
                'seed_config_file'      => '/some/seedfile',
                'seed_user'             => 'adminuser',
                'password_hash'         => 'abcdefghijklmnop',
                'splunk_user'           => 'someuser',
                'service'               => 'theforwarderservice',
                'mode'                  => 'agent', }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file('/some/conffile').with(ensure: 'absent') }
            it { is_expected.to contain_file('/some/seedfile').with(ensure: 'file', owner: 'someuser', group: 'someuser') }
            it { is_expected.to contain_file('/some/seedfile').with_content(%r{USERNAME=adminuser}) }
            it { is_expected.to contain_file('/some/seedfile').with_content(%r{HASHED_PASSWORD=abcdefghijklmnop}) }
            it { is_expected.not_to contain_service('theforwarderservice') }
          end

          context 'do maintain seed_config_file if we are installing via bolt' do
            # no splunkforwarder_version fact and reset_seeded_password=false is 'installing'
            let(:facts) { facts }
            let(:params) do
              { 'reset_seeded_password' => false,
                'password_config_file'  => '/some/conffile',
                'seed_config_file'      => '/some/seedfile',
                'seed_user'             => 'adminuser',
                'password_hash'         => 'abcdefghijklmnop',
                'splunk_user'           => 'someuser',
                'service'               => 'theforwarderservice',
                'mode'                  => 'bolt', }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file('/some/conffile').with(ensure: 'absent') }
            it { is_expected.to contain_file('/some/seedfile').with(ensure: 'file', owner: 'someuser', group: 'someuser') }
            it { is_expected.to contain_file('/some/seedfile').with_content(%r{USERNAME=adminuser}) }
            it { is_expected.to contain_file('/some/seedfile').with_content(%r{HASHED_PASSWORD=abcdefghijklmnop}) }
            it { is_expected.to contain_service('theforwarderservice').with(ensure: 'running', enable: true) }
          end

        end
      end
    end
  end
end
