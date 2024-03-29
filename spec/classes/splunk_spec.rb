# frozen_string_literal: true

require 'spec_helper'

describe 'splunk' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      next if facts[:os]['name'] == 'windows' # Splunk Server not used supported on windows

      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'splunk class without any parameters' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('splunk') }
        end
      end
    end
  end
end
