# frozen_string_literal: true

require 'spec_helper'

shared_examples_for 'splunk forwarder' do
  it { is_expected.to contain_class('splunk') }
  it { is_expected.to contain_class('splunk::params') }
  it { is_expected.to contain_class('splunk::forwarder') }
  it { is_expected.to contain_class('splunk::forwarder::install') }
  it { is_expected.to contain_class('splunk::forwarder::config') }
  it { is_expected.to contain_class('splunk::forwarder::service') }
  it { is_expected.to contain_splunk_config('splunk') }
  it { is_expected.to contain_splunkforwarder_web('forwarder_splunkd_port').with(value: '127.0.0.1:8089') }
end

describe 'splunk::forwarder' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        if facts[:os]['name'] == 'windows'
          let(:facts) do
            facts.merge(facts.merge(archive_windir: 'C:\\ProgramData\\Staging'))
          end
          it { is_expected.to contain_package('UniversalForwarder').with(ensure: 'installed') }
          it { is_expected.to contain_file('C:\\Program Files\\SplunkUniversalForwarder/etc/system/local/deploymentclient.conf') }
          it { is_expected.to contain_file('C:\\Program Files\\SplunkUniversalForwarder/etc/system/local/outputs.conf') }
          it { is_expected.to contain_file('C:\\Program Files\\SplunkUniversalForwarder/etc/system/local/inputs.conf') }
          it { is_expected.to contain_file('C:\\Program Files\\SplunkUniversalForwarder/etc/system/local/limits.conf') }
          it { is_expected.to contain_file('C:\\Program Files\\SplunkUniversalForwarder/etc/system/local/props.conf') }
          it { is_expected.to contain_file('C:\\Program Files\\SplunkUniversalForwarder/etc/system/local/transforms.conf') }
          it { is_expected.to contain_file('C:\\Program Files\\SplunkUniversalForwarder/etc/system/local/web.conf') }
          it { is_expected.to contain_file('C:\\Program Files\\SplunkUniversalForwarder/etc/system/local/server.conf') }
          it { is_expected.not_to contain_file('C:\\Program Files\\SplunkUniversalForwarder/etc/auth/splunk.secret') }
          it { is_expected.not_to contain_file('C:\\Program Files\\SplunkUniversalForwarder/etc/passwd') }
        else
          it { is_expected.to contain_package('splunkforwarder').with(ensure: 'installed') }
          it { is_expected.to contain_file('/opt/splunkforwarder/etc/system/local/deploymentclient.conf') }
          it { is_expected.to contain_file('/opt/splunkforwarder/etc/system/local/outputs.conf') }
          it { is_expected.to contain_file('/opt/splunkforwarder/etc/system/local/inputs.conf') }
          it { is_expected.to contain_file('/opt/splunkforwarder/etc/system/local/limits.conf') }
          it { is_expected.to contain_file('/opt/splunkforwarder/etc/system/local/props.conf') }
          it { is_expected.to contain_file('/opt/splunkforwarder/etc/system/local/transforms.conf') }
          it { is_expected.to contain_file('/opt/splunkforwarder/etc/system/local/web.conf') }
          it { is_expected.to contain_file('/opt/splunkforwarder/etc/system/local/server.conf') }
          it { is_expected.not_to contain_file('/opt/splunkforwarder/etc/auth/splunk.secret') }
          it { is_expected.not_to contain_file('/opt/splunkforwarder/etc/passwd') }
        end
        it { is_expected.to compile.with_all_deps }

        context 'splunk when including forwarder and enterprise' do
          let(:pre_condition) do
            'include splunk::enterprise'
          end

          it { is_expected.to compile.and_raise_error(%r{Do not include splunk::forwarder on the same node as splunk::enterprise}) }
        end

        context 'when manage_password = true' do
          if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'
            let(:params) { { 'manage_password' => true } }

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file('/opt/splunkforwarder/etc/auth/splunk.secret') }
            it { is_expected.to contain_file('/opt/splunkforwarder/etc/passwd') }
          end
        end

        context 'when package_provider = yum' do
          if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'
            let(:params) { { 'package_provider' => 'yum' } }

            it { is_expected.to contain_package('splunkforwarder').with(provider: 'yum') }
          end
        end

        context 'with $boot_start = true (defaults)' do
          if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'

            context 'with $facts[service_provider] == init and $splunk::params::version >= 7.2.2' do
              let(:facts) do
                facts.merge(service_provider: 'init')
              end
              let(:pre_condition) do
                "class { 'splunk::params': version => '7.2.2' }"
              end

              it_behaves_like 'splunk forwarder'
              it { is_expected.to contain_class('splunk::forwarder::service::nix') }
              it { is_expected.to contain_class('splunk::forwarder').with(service_name: 'splunk') }
              it { is_expected.to contain_exec('stop_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk stop') }
              it { is_expected.to contain_exec('enable_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk enable boot-start -user root  --accept-license --answer-yes --no-prompt') }
              it { is_expected.not_to contain_exec('disable_splunkforwarder') }
              it { is_expected.not_to contain_exec('license_splunkforwarder') }
              it { is_expected.to contain_service('splunk').with(ensure: 'running', enable: true, status: nil, restart: nil, start: nil, stop: nil) }
            end

            context 'with $facts[service_provider] == init and $splunk::params::version < 7.2.2' do
              let(:facts) do
                facts.merge(service_provider: 'init')
              end
              let(:pre_condition) do
                "class { 'splunk::params': version => '6.0.0' }"
              end

              it_behaves_like 'splunk forwarder'
              it { is_expected.to contain_class('splunk::forwarder::service::nix') }
              it { is_expected.to contain_class('splunk::forwarder').with(service_name: 'splunk') }
              it { is_expected.to contain_exec('stop_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk stop') }
              it { is_expected.to contain_exec('enable_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk enable boot-start -user root  --accept-license --answer-yes --no-prompt') }
              it { is_expected.not_to contain_exec('disable_splunkforwarder') }
              it { is_expected.not_to contain_exec('license_splunkforwarder') }
              it { is_expected.to contain_service('splunk').with(ensure: 'running', enable: true, status: nil, restart: nil, start: nil, stop: nil) }
            end

            context 'with $facts[service_provider] == systemd and $splunk::params::version >= 7.2.2' do
              let(:facts) do
                facts.merge(service_provider: 'systemd')
              end
              let(:pre_condition) do
                "class { 'splunk::params': version => '7.2.2' }"
              end

              it_behaves_like 'splunk forwarder'
              it { is_expected.to contain_class('splunk::forwarder::service::nix') }
              it { is_expected.to contain_class('splunk::forwarder').with(service_name: 'SplunkForwarder') }
              it { is_expected.to contain_exec('stop_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk stop') }
              it { is_expected.to contain_exec('enable_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk enable boot-start -user root -systemd-managed 1 --accept-license --answer-yes --no-prompt') }
              it { is_expected.not_to contain_exec('disable_splunkforwarder') }
              it { is_expected.not_to contain_exec('license_splunkforwarder') }
              it { is_expected.to contain_service('SplunkForwarder').with(ensure: 'running', enable: true, status: nil, restart: nil, start: nil, stop: nil) }
            end

            context 'with $facts[service_provider] == systemd and $splunk::params::version >= 7.2.2 and user != root' do
              let(:facts) do
                facts.merge(service_provider: 'systemd')
              end
              let(:pre_condition) do
                "class { 'splunk::params': version => '7.2.2' }"
              end
              let(:params) { { splunk_user: 'splunk' } }

              it { is_expected.to contain_exec('enable_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk enable boot-start -user splunk -systemd-managed 1 --accept-license --answer-yes --no-prompt') }
            end

            context 'with $facts[service_provider] == systemd and $splunk::params::version < 7.2.2' do
              let(:facts) do
                facts.merge(service_provider: 'systemd')
              end
              let(:pre_condition) do
                "class { 'splunk::params': version => '6.0.0' }"
              end

              it_behaves_like 'splunk forwarder'
              it { is_expected.to contain_class('splunk::forwarder::service::nix') }
              it { is_expected.to contain_class('splunk::forwarder').with(service_name: 'splunk') }
              it { is_expected.to contain_exec('stop_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk stop') }
              it { is_expected.to contain_exec('enable_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk enable boot-start -user root  --accept-license --answer-yes --no-prompt') }
              it { is_expected.not_to contain_exec('disable_splunkforwarder') }
              it { is_expected.not_to contain_exec('license_splunkforwarder') }
              it { is_expected.to contain_service('splunk').with(ensure: 'running', enable: true, status: nil, restart: nil, start: nil, stop: nil) }
            end

          end
        end

        context 'with $boot_start = false' do
          if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'

            context 'with $facts[service_provider] == init and $splunk::params::version >= 7.2.2' do
              let(:facts) do
                facts.merge(service_provider: 'init')
              end
              let(:pre_condition) do
                "class { 'splunk::params': version => '7.2.2', boot_start => false }"
              end

              it_behaves_like 'splunk forwarder'
              it { is_expected.to contain_class('splunk::forwarder::service::nix') }
              it { is_expected.to contain_class('splunk::forwarder').with(service_name: 'splunk') }
              it { is_expected.not_to contain_exec('stop_splunkforwarder') }
              it { is_expected.not_to contain_exec('enable_splunkforwarder') }
              it { is_expected.to contain_exec('disable_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk disable boot-start -user root --accept-license --answer-yes --no-prompt') }
              it { is_expected.to contain_exec('license_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk ftr --accept-license --answer-yes --no-prompt') }
              it { is_expected.to contain_service('splunk').with(restart: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk restart'", start: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk start'", stop: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk stop'", status: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk status'") }
            end

            context 'with $facts[service_provider] == init and $splunk::params::version < 7.2.2' do
              let(:facts) do
                facts.merge(service_provider: 'init')
              end
              let(:pre_condition) do
                "class { 'splunk::params': version => '6.0.0', boot_start => false }"
              end

              it_behaves_like 'splunk forwarder'
              it { is_expected.to contain_class('splunk::forwarder::service::nix') }
              it { is_expected.to contain_class('splunk::forwarder').with(service_name: 'splunk') }
              it { is_expected.not_to contain_exec('stop_splunkforwarder') }
              it { is_expected.not_to contain_exec('enable_splunkforwarder') }
              it { is_expected.to contain_exec('disable_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk disable boot-start -user root --accept-license --answer-yes --no-prompt') }
              it { is_expected.to contain_exec('license_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk ftr --accept-license --answer-yes --no-prompt') }
              it { is_expected.to contain_service('splunk').with(restart: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk restart'", start: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk start'", stop: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk stop'", status: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk status'") }
            end

            context 'with $facts[service_provider] == systemd and $splunk::params::version >= 7.2.2' do
              let(:facts) do
                facts.merge(service_provider: 'systemd')
              end
              let(:pre_condition) do
                "class { 'splunk::params': version => '7.2.2', boot_start => false }"
              end

              it_behaves_like 'splunk forwarder'
              it { is_expected.to contain_class('splunk::forwarder::service::nix') }
              it { is_expected.to contain_class('splunk::forwarder').with(service_name: 'SplunkForwarder') }
              it { is_expected.not_to contain_exec('stop_splunkforwarder') }
              it { is_expected.not_to contain_exec('enable_splunkforwarder') }
              it { is_expected.to contain_exec('disable_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk disable boot-start -user root --accept-license --answer-yes --no-prompt') }
              it { is_expected.to contain_exec('license_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk ftr --accept-license --answer-yes --no-prompt') }
              it { is_expected.to contain_service('SplunkForwarder').with(restart: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk restart'", start: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk start'", stop: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk stop'", status: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk status'") }
            end

            context 'with $facts[service_provider] == systemd and $splunk::params::version < 7.2.2' do
              let(:facts) do
                facts.merge(service_provider: 'systemd')
              end
              let(:pre_condition) do
                "class { 'splunk::params': version => '6.0.0', boot_start => false }"
              end

              it_behaves_like 'splunk forwarder'
              it { is_expected.to contain_class('splunk::forwarder::service::nix') }
              it { is_expected.to contain_class('splunk::forwarder').with(service_name: 'splunk') }
              it { is_expected.not_to contain_exec('stop_splunkforwarder') }
              it { is_expected.not_to contain_exec('enable_splunkforwarder') }
              it { is_expected.to contain_exec('disable_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk disable boot-start -user root --accept-license --answer-yes --no-prompt') }
              it { is_expected.to contain_exec('license_splunkforwarder').with(command: '/opt/splunkforwarder/bin/splunk ftr --accept-license --answer-yes --no-prompt') }
              it { is_expected.to contain_service('splunk').with(restart: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk restart'", start: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk start'", stop: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk stop'", status: "/usr/sbin/runuser -l root -c '/opt/splunkforwarder/bin/splunk status'") }
            end

          end
        end

        context 'when forwarder not already installed' do
          let(:facts) do
            facts.merge(splunkforwarder_version: nil, service_provider: facts[:kernel] == 'FreeBSD' ? 'freebsd' : 'systemd')
          end
          let(:pre_condition) do
            "class { 'splunk::params': version => '7.2.2' }"
          end
          let(:accept_tos_command) do
            '/opt/splunkforwarder/bin/splunk stop && /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes && /opt/splunkforwarder/bin/splunk stop'
          end
          let(:service_name) do
            facts[:kernel] == 'FreeBSD' ? 'splunk' : 'SplunkForwarder'
          end

          it_behaves_like 'splunk forwarder'
          if facts[:os]['name'] != 'windows'
            it do
              is_expected.to contain_exec('splunk-forwarder-accept-tos').with(
                command: accept_tos_command,
                user: 'root',
                before: "Service[#{service_name}]",
                subscribe: nil,
                require: 'Exec[enable_splunkforwarder]',
                refreshonly: 'true'
              )
            end
          end
        end

        context 'when forwarder already installed' do
          let(:facts) do
            facts.merge(splunkforwarder_version: '7.3.3', service_provider: facts[:kernel] == 'FreeBSD' ? 'freebsd' : 'systemd')
          end
          let(:pre_condition) do
            "class { 'splunk::params': version => '7.2.2' }"
          end
          let(:accept_tos_command) do
            '/opt/splunkforwarder/bin/splunk stop && /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes && /opt/splunkforwarder/bin/splunk stop'
          end
          let(:service_name) do
            facts[:kernel] == 'FreeBSD' ? 'splunk' : 'SplunkForwarder'
          end

          it_behaves_like 'splunk forwarder'
          it do
            if facts[:os]['name'] != 'windows'
              is_expected.to contain_exec('splunk-forwarder-accept-tos').with(
                command: accept_tos_command,
                user: 'root',
                before: "Service[#{service_name}]",
                subscribe: 'Package[splunkforwarder]',
                require: 'Exec[enable_splunkforwarder]',
                refreshonly: 'true'
              )
            end
          end

          context 'when $splunk::params::manage_net_tools == false' do
            let(:pre_condition) do
              "class { 'splunk::params': manage_net_tools => false }"
            end

            it { is_expected.not_to contain_package('net-tools') }
          end

          if os.start_with?('solaris')
            context 'when running on solaris' do
              it { is_expected.not_to contain_package('net-tools') }
            end
          end
        end
      end
    end
  end
end
