require 'spec_helper'

describe 'splunk::forwarder' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'with forwarder_output set to undef' do
        let(:params) { { 'forwarder_output' => :undef } }

        it { is_expected.to compile.with_all_deps }
      end

      context 'with forwarder_input set to undef' do
        let(:params) { { 'forwarder_input' => :undef } }

        it { is_expected.to compile.with_all_deps }
      end

      context 'with pkg_provider set to yum and manage_package_source set to false' do
        let(:params) do
          {
            'pkg_provider'          => 'yum',
            'package_name'          => 'splunk_forwarder_X',
            'manage_package_source' => false
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('splunk_forwarder_X').with_provider('yum').without_source }
      end
    end
  end
end
