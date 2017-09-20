require 'spec_helper'

describe 'splunk::forwarder' do
  on_supported_os.each do |os, os_facts |
    context "on #{os}" do
      let(:facts) { os_facts }
     
      context 'with defaults' do
        if (os == 'solaris-11-i86pc')
          pending
        else
          it { is_expected.to compile.with_all_deps }
        end
      end
    end
  end
end