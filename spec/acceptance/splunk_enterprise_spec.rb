# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'splunk enterprise class' do
  init = shell('/bin/readlink /sbin/init', acceptable_exit_codes: [0, 1]).stdout
  service_name = if init.include? 'systemd'
                   'Splunkd'
                 else
                   'splunk'
                 end

  OLD_SPLUNK_VERSIONS.each do |version, build|
    context "Splunk version #{version}" do
      after(:all) do
        pp = <<-EOS
        service { '#{service_name}': ensure => stopped }
        package { 'splunk': ensure => purged }
        file { '/opt/splunk': ensure => absent, force => true, require => Package['splunk'] }
        file { '/etc/init.d/splunk': ensure => absent, require => Package['splunk'] }
        file { '/etc/systemd/system/Splunkd.service': ensure => absent, require => Package['splunk'] }
        EOS
        apply_manifest(pp, catch_failures: true)
      end

      it 'works idempotently with no errors' do
        pp = <<-EOS
        class { 'splunk::params': version => '#{version}', build => '#{build}' }
        class { 'splunk::enterprise': }

        # See https://community.splunk.com/t5/Installation/Why-am-I-getting-an-error-to-start-a-fresh-Splunk-instance-in-my/m-p/336938
        file_line { 'file_locking':
          path => '/opt/splunk/etc/splunk-launch.conf',
          line => 'OPTIMISTIC_ABOUT_FILE_LOCKING=1',
          before => Exec['enable_splunk'],
          require => Package['splunk'],
        }
        EOS

        # Run it twice and test for idempotency
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
        # give splunk some time to start
        sleep(10)
      end

      describe package('splunk') do
        it { is_expected.to be_installed }
      end

      describe service(service_name) do
        it { is_expected.to be_enabled }
        it { is_expected.to be_running }
      end
    end
  end

  context 'Upgrading splunk enterprise from 9.1.0 to 9.2.0.1' do
    after(:all) do
      pp = <<-EOS
        service { '#{service_name}': ensure => stopped }
        package { 'splunk': ensure => purged }
        file { '/opt/splunk': ensure => absent, force => true, require => Package['splunk'] }
        file { '/etc/init.d/splunk': ensure => absent, require => Package['splunk'] }
        file { '/etc/systemd/system/Splunkd.service': ensure => absent, require => Package['splunk'] }
      EOS
      apply_manifest(pp, catch_failures: true)
    end

    it 'works idempotently with no errors' do
      pp = <<-EOS
        class { 'splunk::params': version => '9.1.0', build => '1c86ca0bacc3' }
        class { 'splunk::enterprise':  }

        # See https://community.splunk.com/t5/Installation/Why-am-I-getting-an-error-to-start-a-fresh-Splunk-instance-in-my/m-p/336938
        file_line { 'file_locking':
          path => '/opt/splunk/etc/splunk-launch.conf',
          line => 'OPTIMISTIC_ABOUT_FILE_LOCKING=1',
          before => Exec['enable_splunk'],
          require => Package['splunk'],
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
      # give splunk some time to start
      sleep(10)
    end

    describe package('splunk') do
      it { is_expected.to be_installed }
    end

    describe service(service_name) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    it 'upgrades to 9.2.0.1' do
      pp = <<-EOS
        class { 'splunk::params': version => '9.2.0.1', build => 'd8ae995bf219' }
        class { 'splunk::enterprise': package_ensure => latest  }

        # See https://community.splunk.com/t5/Installation/Why-am-I-getting-an-error-to-start-a-fresh-Splunk-instance-in-my/m-p/336938
        file_line { 'file_locking':
          path => '/opt/splunk/etc/splunk-launch.conf',
          line => 'OPTIMISTIC_ABOUT_FILE_LOCKING=1',
          before => Exec['enable_splunk'],
          require => Package['splunk'],
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
      # give splunk some time to start
      sleep(10)
    end
  end

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'splunk::enterprise': }

      # See https://community.splunk.com/t5/Installation/Why-am-I-getting-an-error-to-start-a-fresh-Splunk-instance-in-my/m-p/336938
      file_line { 'file_locking':
        path => '/opt/splunk/etc/splunk-launch.conf',
        line => 'OPTIMISTIC_ABOUT_FILE_LOCKING=1',
        before => Exec['enable_splunk'],
        require => Package['splunk'],
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
      # give splunk some time to start
      sleep(10)
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
        it { is_expected.to be_owned_by 'splunk' }
        it { is_expected.to be_grouped_into 'splunk' }
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
        # give splunk some time to start
        sleep(10)
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
