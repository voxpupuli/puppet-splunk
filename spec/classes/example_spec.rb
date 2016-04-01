require 'spec_helper'

describe 'splunk' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "splunk class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('splunk::params') }
          it { is_expected.to contain_class('splunk::install').that_comes_before('splunk::config') }
          it { is_expected.to contain_class('splunk::config') }
          it { is_expected.to contain_class('splunk::service').that_subscribes_to('splunk::config') }

          it { is_expected.to contain_service('splunk') }
          it { is_expected.to contain_package('splunk').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'splunk class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('splunk') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
