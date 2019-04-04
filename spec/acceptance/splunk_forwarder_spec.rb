require 'spec_helper_acceptance'

describe 'splunk::forwarder class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'splunk::params':
      }
      class { 'splunk::forwarder':
        splunkd_port => 8090,
      }
      splunkforwarder_output { 'tcpout:splunkcloud/sslPassword':
        value => 'super_secure_password',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/opt/splunkforwarder/etc/system/local/outputs.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{^sslPassword} }
      its(:content) { is_expected.to match %r{^sslPassword = \$7\$} }
    end

    describe package('splunkforwarder') do
      it { is_expected.to be_installed }
    end

    init = shell('/bin/readlink /sbin/init', acceptable_exit_codes: [0, 1]).stdout
    service_name = if init.include? 'systemd'
                     'SplunkForwarder'
                   else
                     'splunk'
                   end

    describe service(service_name) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
  context 'purging' do
    context 'purge_outputs => false' do
      it 'works idempotently with no errors' do
        pp = <<-eos
      class { 'splunk::params':
      }
      class { 'splunk::forwarder':
        splunkd_port  => 8090,
        purge_outputs => false,
      }
        eos

        # run it twice and test for idempotency
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end

      describe file('/opt/splunkforwarder/etc/system/local/outputs.conf') do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match %r{^sslPassword} }
      end
    end
    context 'purge_outputs => true' do
      it 'works idempotently with no errors' do
        pp = <<-eos
      class { 'splunk::params':
      }
      class { 'splunk::forwarder':
        splunkd_port  => 8090,
        purge_outputs => true,
      }
        eos

        # run it twice and test for idempotency
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end

      describe file('/opt/splunkforwarder/etc/system/local/outputs.conf') do
        it { is_expected.to be_file }
        its(:content) { is_expected.not_to match %r{^sslPassword} }
      end
    end
  end
end
