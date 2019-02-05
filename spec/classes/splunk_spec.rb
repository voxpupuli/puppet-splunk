require 'spec_helper'

describe 'splunk' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      if os.start_with?('windows')
        # Splunk Server not supported on windows
      else
        context "on #{os}" do
          let(:facts) do
            facts
          end

          context 'splunk class with legacy_mode = false and boot_start = true (defaults)' do
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('splunk') }
            it { is_expected.to contain_class('splunk::params') }
            it { is_expected.to contain_package('splunk').with_ensure('installed') }
            it { is_expected.to contain_exec('enable_splunk') }

            if facts[:kernel] == 'Linux' or facts[:kernel] == 'SunOS'
              context 'with service_provider init' do
                let(:facts) do
                  facts.merge({
                    :service_provider => 'init',
                  })
                end
                it { is_expected.to contain_exec('enable_splunk').with(:creates => '/etc/init.d/splunk' ) }
                it { is_expected.to_not contain_exec('license_splunk') }
                it { is_expected.to contain_service('splunk').with({:restart => nil, :start => nil, :stop => nil, :provider => nil}) }
                it { is_expected.to_not contain_service('splunkd') }
                it { is_expected.to_not contain_service('splunkweb') }
                it { is_expected.to_not contain_service('Splunkd') }
              end

              context 'splunk::version >= 7.2.2 with service_provider systemd' do
                let(:facts) do
                  facts.merge({
                    :service_provider => 'systemd',
                  })
                end
                let(:pre_condition) {
                  """
                  class { 'splunk::params':
                    version => '7.2.2'
                  }
                  """
                }
                it { is_expected.to contain_exec('enable_splunk').with(:creates => '/etc/systemd/system/multi-user.target.wants/Splunkd.service' ) }
                it { is_expected.to_not contain_exec('license_splunk') }
                it { is_expected.to contain_service('Splunkd').with({:restart => nil, :start => nil, :stop => nil, :provider => nil}) }
                it { is_expected.to_not contain_service('splunk') }
                it { is_expected.to_not contain_service('splunkd') }
                it { is_expected.to_not contain_service('splunkweb') }
              end

              context 'splunk::version < 7.2.2 with service_provider systemd' do
                let(:facts) do
                  facts.merge({
                    :service_provider => 'systemd',
                  })
                end
                it { is_expected.to contain_exec('enable_splunk').with(:creates => '/etc/systemd/system/multi-user.target.wants/Splunkd.service' ) }
                it { is_expected.to_not contain_exec('license_splunk') }
                it { is_expected.to contain_service('splunk') }
                it { is_expected.to_not contain_service('Splunkd') }
                it { is_expected.to_not contain_service('splunkd') }
                it { is_expected.to_not contain_service('splunkweb') }
              end
            end
          end

          context 'splunk class with legacy_mode = true and boot_start = true' do
            let(:pre_condition) {
              """
              class { 'splunk::params':
                legacy_mode => true,
                boot_start => true
              }
              """
            }
            it { expect { is_expected.to contain_class('splunk') }.to raise_error(Puppet::Error, %r{Splunk boot-start mode is enabled, you should not run in legacy mode.}) }
          end

          context 'splunk class with legacy_mode = false and boot_start = false' do
            let(:pre_condition) {
              """
              class { 'splunk::params':
                legacy_mode => false,
                boot_start => false
              }
              """
            }
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('splunk') }
            it { is_expected.to_not contain_exec('enable_splunk') }
            it { is_expected.to contain_exec('license_splunk') }

            if facts[:kernel] == 'Linux' or facts[:kernel] == 'SunOS'
              context 'with service_provider init' do
                let(:facts) do
                  facts.merge({
                    :service_provider => 'init',
                  })
                end
                it { is_expected.to_not contain_service('splunkd') }
                it { is_expected.to_not contain_service('splunkweb') }
                it { is_expected.to_not contain_service('Splunkd') }
                it { is_expected.to contain_service('splunk').with({
                  :restart  => '/opt/splunk/bin/splunk restart',
                  :start    => '/opt/splunk/bin/splunk start',
                  :stop     => '/opt/splunk/bin/splunk stop',
                  :provider => 'base'})
                }
              end

              context 'splunk::version >= 7.2.2 with service_provider systemd' do
                let(:facts) do
                  facts.merge({
                    :service_provider => 'systemd',
                  })
                end
                let(:pre_condition) {
                  """
                  class { 'splunk::params':
                    version => '7.2.2',
                    legacy_mode => false,
                    boot_start => false
                  }
                  """
                }
                it { is_expected.to_not contain_service('splunk') }
                it { is_expected.to_not contain_service('splunkd') }
                it { is_expected.to_not contain_service('splunkweb') }
                it { is_expected.to contain_service('Splunkd').with({
                  :restart  => '/opt/splunk/bin/splunk restart',
                  :start    => '/opt/splunk/bin/splunk start',
                  :stop     => '/opt/splunk/bin/splunk stop',
                  :provider => 'base'})
                }
              end

              context 'splunk::version < 7.2.2 with service_provider systemd' do
                let(:facts) do
                  facts.merge({
                    :service_provider => 'systemd',
                  })
                end
                it { is_expected.to_not contain_service('Splunkd') }
                it { is_expected.to_not contain_service('splunkd') }
                it { is_expected.to_not contain_service('splunkweb') }
                it { is_expected.to contain_service('splunk').with({
                  :restart  => '/opt/splunk/bin/splunk restart',
                  :start    => '/opt/splunk/bin/splunk start',
                  :stop     => '/opt/splunk/bin/splunk stop',
                  :provider => 'base'})
                }
              end
            end
          end

          context 'splunk class with legacy_mode = true and boot_start = false' do
            let(:pre_condition) {
              """
              class { 'splunk::params':
                legacy_mode => true,
                boot_start => false
              }
              """
            }
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('splunk') }
            it { is_expected.to_not contain_exec('enable_splunk') }
            it { is_expected.to contain_exec('license_splunk') }

            if facts[:kernel] == 'Linux' or facts[:kernel] == 'SunOS'
              context 'with service_provider init' do
                let(:facts) do
                  facts.merge({
                    :service_provider => 'init',
                  })
                end
                it { is_expected.to_not contain_service('splunk') }
                it { is_expected.to_not contain_service('Splunkd') }
                it { is_expected.to contain_service('splunkd').with({
                  :restart  => '/opt/splunk/bin/splunk restart splunkd',
                  :start    => '/opt/splunk/bin/splunk start splunkd',
                  :stop     => '/opt/splunk/bin/splunk stop splunkd',
                  :provider => 'base'})
                }
                it { is_expected.to contain_service('splunkweb').with({
                  :restart  => '/opt/splunk/bin/splunk restart splunkweb',
                  :start    => '/opt/splunk/bin/splunk start splunkweb',
                  :stop     => '/opt/splunk/bin/splunk stop splunkweb',
                  :provider => 'base'})
                }
              end

              context 'splunk::version > 7.2.2 with service_provider systemd' do
                let(:facts) do
                  facts.merge({
                    :service_provider => 'systemd',
                  })
                end
                let(:pre_condition) {
                  """
                  class { 'splunk::params':
                    version => '7.2.2',
                    legacy_mode => true,
                    boot_start => false
                  }
                  """
                }
                it { is_expected.to_not contain_service('splunk') }
                it { is_expected.to_not contain_service('Splunkd') }
                it { is_expected.to contain_service('splunkd').with({
                  :restart  => '/opt/splunk/bin/splunk restart splunkd',
                  :start    => '/opt/splunk/bin/splunk start splunkd',
                  :stop     => '/opt/splunk/bin/splunk stop splunkd',
                  :provider => 'base'})
                }
                it { is_expected.to contain_service('splunkweb').with({
                  :restart  => '/opt/splunk/bin/splunk restart splunkweb',
                  :start    => '/opt/splunk/bin/splunk start splunkweb',
                  :stop     => '/opt/splunk/bin/splunk stop splunkweb',
                  :provider => 'base'})
                }
              end

              context 'splunk::version < 7.2.2 with service_provider systemd' do
                let(:facts) do
                  facts.merge({
                    :service_provider => 'systemd',
                  })
                end
                it { is_expected.to_not contain_service('splunk') }
                it { is_expected.to_not contain_service('Splunkd') }
                it { is_expected.to contain_service('splunkd').with({
                  :restart  => '/opt/splunk/bin/splunk restart splunkd',
                  :start    => '/opt/splunk/bin/splunk start splunkd',
                  :stop     => '/opt/splunk/bin/splunk stop splunkd',
                  :provider => 'base'})
                }
                it { is_expected.to contain_service('splunkweb').with({
                  :restart  => '/opt/splunk/bin/splunk restart splunkweb',
                  :start    => '/opt/splunk/bin/splunk start splunkweb',
                  :stop     => '/opt/splunk/bin/splunk stop splunkweb',
                  :provider => 'base'})
                }
              end
            end
          end

        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'splunk class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          os: {
            family:       'Solaris',
            name:         'Nexenta',
            architecture: 'sparc'
          },
          osfamily:        'Solaris',
          operatingsystem: 'Nexenta',
          kernel:          'SunOS',
          architecture:    'sparc'
        }
      end

      it { expect { is_expected.to contain_package('splunk') }.to raise_error(Puppet::Error, %r{unsupported osfamily/arch Solaris/sparc}) }
    end
  end
end
