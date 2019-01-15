require 'spec_helper_acceptance'

describe 'splunk class' do

  splunk_host = only_host_with_role(hosts, 'master')

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { '::splunk': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('splunk') do
      it { is_expected.to be_installed }
    end

    service_provider = fact_on(splunk_host, 'service_provider')
    case service_provider
    when /systemd/
      splunk_service = 'Splunkd'
    else
      splunk_service = 'splunk'
    end

    describe service(splunk_service) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    SPLUNK_TYPES.select { |type| SPLUNK_SERVER_TYPES.key?(type) }.each do |type, file_name|
      context = type == :splunk_metadata ? 'metadata' : 'local'
      conf_file_path = File.join('/opt/splunk/etc/system', context, file_name)
      describe file(conf_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to be_mode 600 }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
      end
    end
  end
end
