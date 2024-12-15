# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'splunk::forwarder class' do
  init = shell('/bin/readlink /sbin/init', acceptable_exit_codes: [0, 1]).stdout
  service_name = if init.include? 'systemd'
                   'SplunkForwarder'
                 else
                   'splunk'
                 end

  OLD_SPLUNK_VERSIONS.each do |version, build|
    context "Splunk forwarder version #{version}" do
      after(:all) do
        pp = <<-EOS
        service { '#{service_name}': ensure => stopped }
        package { 'splunkforwarder': ensure => purged }
        file { '/opt/splunkforwarder': ensure => absent, force => true, require => Package['splunkforwarder'] }
        file { '/opt/splunk': ensure => absent, force => true, require => Package['splunkforwarder'] }
        file { '/etc/systemd/system/SplunkForwarder.service': ensure => absent, require => Package['splunkforwarder'] }
        EOS
        apply_manifest(pp, catch_failures: true)
      end

      it 'works idempotently with no errors' do
        pp = <<-EOS
        class { 'splunk::params': version => '#{version}', build => '#{build}' }
        class { 'splunk::forwarder':
          splunkd_port => 8090,
        }
        EOS

        # Run it twice and test for idempotency
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end

      describe package('splunkforwarder') do
        it { is_expected.to be_installed }
      end

      describe service(service_name) do
        it { is_expected.to be_enabled }
        it { is_expected.to be_running }
      end
    end
  end

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

    describe service(service_name) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'purging' do
    context 'purge_outputs => false' do
      it 'works idempotently with no errors' do
        pp = <<-EOS
      class { 'splunk::params':
      }
      class { 'splunk::forwarder':
        splunkd_port  => 8090,
        purge_outputs => false,
      }
        EOS

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
        pp = <<-EOS
      class { 'splunk::params':
      }
      class { 'splunk::forwarder':
        splunkd_port  => 8090,
        purge_outputs => true,
      }
        EOS

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
