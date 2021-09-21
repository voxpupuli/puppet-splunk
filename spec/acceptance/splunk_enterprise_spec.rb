require 'spec_helper_acceptance'

describe 'splunk enterprise class' do
  init = shell('/bin/readlink /sbin/init', acceptable_exit_codes: [0, 1]).stdout
  service_name = if init.include? 'systemd'
                   'Splunkd'
                 else
                   'splunk'
                 end

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'splunk::enterprise': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('splunk') do
      it { is_expected.to be_installed }
    end

    describe service(service_name) do
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

    context 'seed admin password' do
      # Using puppet_apply as a helper
      it 'works with no errors' do
        pp = <<-EOS
        class { 'splunk::enterprise':
          seed_password         => true,
          reset_seeded_password => true,
          password_hash         => '$6$not4r3alh45h',
        }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      it 'works idempotently with no errors' do
        pp = <<-EOS
        class { 'splunk::enterprise':
          seed_password         => true,
          password_hash         => '$6$not4r3alh45h',
        }
        EOS

        # Run it twice and test for idempotency
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end

      describe file('/opt/splunk/etc/passwd') do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match %r{\$6\$not4r3alh45h} }
      end
    end

    # Uninstall so that splunkforwarder tests aren't affected by this set of tests
    context 'uninstalling splunk' do
      it do
        pp = <<-EOS
        service { '#{service_name}': ensure => stopped }
        package { 'splunk': ensure => purged }
        file { '/opt/splunk': ensure => absent, force => true, require => Package['splunk'] }
        file { '/etc/init.d/splunk': ensure => absent, require => Package['splunk'] }
        EOS
        apply_manifest(pp, catch_failures: true)
      end
      describe package('splunk') do
        it { is_expected.not_to be_installed }
      end
    end
  end
end
