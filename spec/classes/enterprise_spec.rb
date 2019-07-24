require 'spec_helper'

shared_examples_for 'splunk enterprise nix defaults' do
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('splunk::enterprise') }
  it { is_expected.to contain_class('splunk::enterprise::install') }
  it { is_expected.to contain_class('splunk::enterprise::install::nix') }
  it { is_expected.to contain_class('splunk::enterprise::config') }
  it { is_expected.to contain_class('splunk::enterprise::service') }
  it { is_expected.to contain_class('splunk::enterprise::service::nix') }
  it { is_expected.to contain_splunk_config('splunk') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/alert_actions.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/authentication.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/authorize.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/deploymentclient.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/distsearch.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/indexes.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/inputs.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/limits.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/outputs.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/props.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/server.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/serverclass.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/transforms.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/ui-prefs.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/local/web.conf') }
  it { is_expected.to contain_file('/opt/splunk/etc/system/metadata/local.meta') }
  it { is_expected.to contain_splunk_input('default_host') }
  it { is_expected.to contain_splunk_input('default_splunktcp').with(section: 'splunktcp://:9997', value: 'dns') }
  it { is_expected.to contain_splunk_web('splunk_server_splunkd_port').with(value: '127.0.0.1:8089') }
  it { is_expected.to contain_splunk_web('splunk_server_web_port').with(value: '8000') }
  it { is_expected.not_to contain_file('/opt/splunk/etc/splunk.secret') }
  it { is_expected.not_to contain_file('/opt/splunk/etc/passwd') }
end

describe 'splunk::enterprise' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      if os.start_with?('windows')
        # Splunk Server not used supported on windows
      else
        context "on #{os}" do
          let(:facts) do
            facts.merge(splunkenterprise: {}, splunkforwarder: {})
          end

          #
          # Test the default parameters, and the version, build, and package_ensure logic
          #

          context 'when including both splunk::forwarder and splunk::enterprise' do
            let(:pre_condition) do
              "class { splunk::forwarder: release => '7.2.4.2-fb30470262e3' }"
            end
            let(:params) { { 'release' => '7.2.4.2-fb30470262e3' } }

            it { expect { is_expected.to contain_class('splunk::enterprise') }.to raise_error(Puppet::Error, %r{Do not include splunk::forwarder on the same node as splunk::enterprise}) }
          end

          context 'with default parmeters and the splunkenterprise[version] fact is undefined' do
            it { expect { is_expected.to contain_class('splunk::enterprise') }.to raise_error(Puppet::Error, %r{No splunk version detected}) }
          end

          context 'with default parameters and the splunkenterprise[version] fact is defined' do
            let(:facts) do
              facts.merge(splunkenterprise: { 'version' => '7.2.4.2', 'build' => 'fb30470262e3' })
            end

            it { is_expected.to compile.with_all_deps }
            if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'
              it_behaves_like 'splunk enterprise nix defaults'
            end
            if %w[sun dpkg].include? facts[:package_provider]
              it { is_expected.to contain_package('splunk').with(ensure: 'installed', source: %r{\/opt\/staging\/splunk\/splunk-7.2.4.2-fb30470262e3}) }
            else
              it { is_expected.to contain_package('splunk').with(ensure: '7.2.4.2-fb30470262e3', source: %r{\/opt\/staging\/splunk\/splunk-7.2.4.2-fb30470262e3}) }
            end
          end

          context 'when $splunk::enterprise::release is specified and $splunk::enterprise::package_ensure is undefined' do
            let(:params) { { 'release' => '7.2.4.2-fb30470262e3' } }

            it { is_expected.to compile.with_all_deps }
            if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'
              it_behaves_like 'splunk enterprise nix defaults'
            end
            if %w[sun dpkg].include? facts[:package_provider]
              it { is_expected.to contain_package('splunk').with(ensure: 'installed', source: %r{\/opt\/staging\/splunk\/splunk-7.2.4.2-fb30470262e3}) }
            else
              it { is_expected.to contain_package('splunk').with(ensure: '7.2.4.2-fb30470262e3', source: %r{\/opt\/staging\/splunk\/splunk-7.2.4.2-fb30470262e3}) }
            end
          end

          context 'when $splunk::enterprise::release is specified and $splunk::enterprise::package_ensure is `absent`' do
            let(:params) { { 'release' => '7.2.4.2-fb30470262e3', 'package_ensure' => 'absent' } }

            if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'
              it_behaves_like 'splunk enterprise nix defaults'
            end
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_package('splunk').with(ensure: 'absent') }
          end

          context 'when $splunk::enterprise::package_ensure and $splunk::enterprise::release are both set to specific versions' do
            let(:params) { { 'release' => '7.2.4.2-fb30470262e3', 'package_ensure' => '6.0.0-fb30470262e3' } }

            # TODO: Test for warning
            # it { expect { is_expected.to contain_class('splunk::enterprise') }.to raise_warning(Puppet::Warning, %r{It is recommended you specify the splunk version}) }
            if %w[sun dpkg].include? facts[:package_provider]
              it { is_expected.to compile.and_raise_error(%r{Provider.*must have features 'versionable' to set 'ensure'}) }
            else
              it { is_expected.to compile.with_all_deps }
            end
          end

          #
          # Test the boot_start logic
          #

          context 'with $boot_start = true (defaults)' do
            if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'

              context 'with $facts[service_provider] == init and $splunk::enterprise::release >= 7.2.2' do
                let(:facts) do
                  facts.merge(service_provider: 'init')
                end
                let(:params) { { 'release' => '7.2.4.2-fb30470262e3' } }

                it { is_expected.to compile.with_all_deps }
                it { is_expected.to contain_package('net-tools').with(ensure: 'present') }
                it { is_expected.not_to contain_file('/etc/init.d/splunk').with(ensure: 'absent') }
                it { is_expected.to contain_exec('stop_splunk').with(command: '/opt/splunk/bin/splunk stop') }
                it { is_expected.to contain_exec('enable_splunk').with(command: '/opt/splunk/bin/splunk enable boot-start -user root --accept-license --answer-yes --no-prompt') }
                it { is_expected.not_to contain_exec('disable_splunk') }
                it { is_expected.not_to contain_exec('license_splunk') }
                it { is_expected.to contain_service('splunk').with(ensure: 'running', enable: true, status: nil, restart: nil, start: nil, stop: nil) }
              end

              context 'with $facts[service_provider] == init and $splunk::enterprise::release < 7.2.2' do
                let(:facts) do
                  facts.merge(service_provider: 'init')
                end
                let(:params) { { 'release' => '6.0.0-fb30470262e3' } }

                it { is_expected.to compile.with_all_deps }
                it { is_expected.not_to contain_package('net-tools').with(ensure: 'present') }
                it { is_expected.not_to contain_file('/etc/init.d/splunk').with(ensure: 'absent') }
                it { is_expected.to contain_exec('stop_splunk').with(command: '/opt/splunk/bin/splunk stop') }
                it { is_expected.to contain_exec('enable_splunk').with(command: '/opt/splunk/bin/splunk enable boot-start -user root --accept-license --answer-yes --no-prompt') }
                it { is_expected.not_to contain_exec('disable_splunk') }
                it { is_expected.not_to contain_exec('license_splunk') }
                it { is_expected.to contain_service('splunk').with(ensure: 'running', enable: true, status: nil, restart: nil, start: nil, stop: nil) }
              end

              context 'with $facts[service_provider] == systemd and $splunk::enterprise::release >= 7.2.2' do
                let(:facts) do
                  facts.merge(service_provider: 'systemd')
                end
                let(:params) { { 'release' => '7.2.4.2-fb30470262e3' } }

                it { is_expected.to compile.with_all_deps }
                it { is_expected.to contain_package('net-tools').with(ensure: 'present') }
                it { is_expected.to contain_file('/etc/init.d/splunk').with(ensure: 'absent') }
                it { is_expected.to contain_exec('stop_splunk').with(command: '/opt/splunk/bin/splunk stop') }
                it { is_expected.to contain_exec('enable_splunk').with(command: '/opt/splunk/bin/splunk enable boot-start -user root --accept-license --answer-yes --no-prompt') }
                it { is_expected.not_to contain_exec('disable_splunk') }
                it { is_expected.not_to contain_exec('license_splunk') }
                it { is_expected.to contain_service('Splunkd').with(ensure: 'running', enable: true, status: nil, restart: nil, start: nil, stop: nil) }
              end

              context 'with $facts[service_provider] == systemd and $splunk::enterprise::release < 7.2.2' do
                let(:facts) do
                  facts.merge(service_provider: 'systemd')
                end
                let(:params) { { 'release' => '6.0.0-fb30470262e3' } }

                it { is_expected.to compile.with_all_deps }
                it { is_expected.not_to contain_package('net-tools').with(ensure: 'present') }
                it { is_expected.not_to contain_file('/etc/init.d/splunk').with(ensure: 'absent') }
                it { is_expected.to contain_exec('stop_splunk').with(command: '/opt/splunk/bin/splunk stop') }
                it { is_expected.to contain_exec('enable_splunk').with(command: '/opt/splunk/bin/splunk enable boot-start -user root --accept-license --answer-yes --no-prompt') }
                it { is_expected.not_to contain_exec('disable_splunk') }
                it { is_expected.not_to contain_exec('license_splunk') }
                it { is_expected.to contain_service('splunk').with(ensure: 'running', enable: true, status: nil, restart: nil, start: nil, stop: nil) }
              end

            end
          end

          context 'with $boot_start = false' do
            if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'

              context 'with $facts[service_provider] == init and $splunk::enterprise::release >= 7.2.2' do
                let(:facts) do
                  facts.merge(service_provider: 'init')
                end
                let(:params) { { 'release' => '7.2.4.2-fb30470262e3', 'boot_start' => false } }

                it { is_expected.to compile.with_all_deps }
                it { is_expected.to contain_package('net-tools').with(ensure: 'present') }
                it { is_expected.not_to contain_file('/etc/init.d/splunk').with(ensure: 'absent') }
                it { is_expected.not_to contain_exec('stop_splunk') }
                it { is_expected.not_to contain_exec('enable_splunk') }
                it { is_expected.to contain_exec('disable_splunk').with(command: '/opt/splunk/bin/splunk disable boot-start -user root --accept-license --answer-yes --no-prompt') }
                it { is_expected.to contain_exec('license_splunk').with(command: '/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt') }
                it { is_expected.to contain_service('splunk').with(restart: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk restart'", start: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk start'", stop: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk stop'", status: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk status'") }
              end

              context 'with $facts[service_provider] == init and $splunk::enterprise::release < 7.2.2' do
                let(:facts) do
                  facts.merge(service_provider: 'init')
                end
                let(:params) { { 'release' => '6.0.0-fb30470262e3', 'boot_start' => false } }

                it { is_expected.to compile.with_all_deps }
                it { is_expected.not_to contain_package('net-tools').with(ensure: 'present') }
                it { is_expected.not_to contain_file('/etc/init.d/splunk').with(ensure: 'absent') }
                it { is_expected.not_to contain_exec('stop_splunk') }
                it { is_expected.not_to contain_exec('enable_splunk') }
                it { is_expected.to contain_exec('disable_splunk').with(command: '/opt/splunk/bin/splunk disable boot-start -user root --accept-license --answer-yes --no-prompt') }
                it { is_expected.to contain_exec('license_splunk').with(command: '/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt') }
                it { is_expected.to contain_service('splunk').with(restart: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk restart'", start: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk start'", stop: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk stop'", status: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk status'") }
              end

              context 'with $facts[service_provider] == systemd and $splunk::enterprise::release >= 7.2.2' do
                let(:facts) do
                  facts.merge(service_provider: 'systemd')
                end
                let(:params) { { 'release' => '7.2.4.2-fb30470262e3', 'boot_start' => false } }

                it { is_expected.to compile.with_all_deps }
                it { is_expected.to contain_package('net-tools').with(ensure: 'present') }
                it { is_expected.to contain_file('/etc/init.d/splunk').with(ensure: 'absent') }
                it { is_expected.not_to contain_exec('stop_splunk') }
                it { is_expected.not_to contain_exec('enable_splunk') }
                it { is_expected.to contain_exec('disable_splunk').with(command: '/opt/splunk/bin/splunk disable boot-start -user root --accept-license --answer-yes --no-prompt') }
                it { is_expected.to contain_exec('license_splunk').with(command: '/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt') }
                it { is_expected.to contain_service('Splunkd').with(restart: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk restart'", start: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk start'", stop: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk stop'", status: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk status'") }
              end

              context 'with $facts[service_provider] == systemd and $splunk::enterprise::release < 7.2.2' do
                let(:facts) do
                  facts.merge(service_provider: 'systemd')
                end
                let(:params) { { 'release' => '6.0.0-fb30470262e3', 'boot_start' => false } }

                it { is_expected.to compile.with_all_deps }
                it { is_expected.not_to contain_package('net-tools').with(ensure: 'present') }
                it { is_expected.not_to contain_file('/etc/init.d/splunk').with(ensure: 'absent') }
                it { is_expected.not_to contain_exec('stop_splunk') }
                it { is_expected.not_to contain_exec('enable_splunk') }
                it { is_expected.to contain_exec('disable_splunk').with(command: '/opt/splunk/bin/splunk disable boot-start -user root --accept-license --answer-yes --no-prompt') }
                it { is_expected.to contain_exec('license_splunk').with(command: '/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt') }
                it { is_expected.to contain_service('splunk').with(restart: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk restart'", start: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk start'", stop: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk stop'", status: "/usr/sbin/runuser -l root -c '/opt/splunk/bin/splunk status'") }
              end

            end
          end

          #
          # Test miscellaneous parameter logic
          #

          context 'when manage_password = true' do
            if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'
              let(:params) { { 'release' => '7.2.4.2-fb30470262e3', 'manage_password' => true } }

              it { is_expected.to compile.with_all_deps }
              it { is_expected.to contain_file('/opt/splunk/etc/splunk.secret') }
              it { is_expected.to contain_file('/opt/splunk/etc/passwd') }
            end
          end

          context 'when package_provider = yum' do
            if facts[:kernel] == 'Linux' || facts[:kernel] == 'SunOS'
              let(:params) { { 'release' => '7.2.4.2-fb30470262e3', 'package_provider' => 'yum' } }

              it { is_expected.to compile.with_all_deps }
              it { is_expected.to contain_package('splunk').with(provider: 'yum') }
            end
          end

          context 'when service_ensure is stopped' do
            let(:facts) do
              facts.merge(service_provider: 'systemd')
            end
            let(:params) { { 'release' => '7.2.4.2-fb30470262e3', 'service_ensure' => 'stopped' } }

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_service('Splunkd').with(ensure: 'stopped') }
          end
        end
      end
    end
  end
end
