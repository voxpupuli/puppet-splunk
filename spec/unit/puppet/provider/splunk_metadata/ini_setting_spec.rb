# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'
require 'tmpdir'

describe Puppet::Type.type(:splunk_metadata).provider(:ini_setting) do
  let(:provider_source) do
    File.expand_path('../../../../../lib/puppet/provider/splunk_metadata/ini_setting.rb', __dir__)
  end

  it 'does not require puppet/util/ini_file from another module' do
    expect(File.read(provider_source)).not_to match(%r{^\s*require ['"]puppet/util/ini_file['"]})
  end

  it 'loads Puppet::Util::IniFile via the inifile provider' do
    expect(described_class).not_to be_nil
    expect(defined?(Puppet::Util::IniFile)).to eq('constant')
  end

  describe SectionNoGlobal do
    subject(:section) { described_class.new(model) }

    let(:model) { Puppet::Util::IniFile::Section.new('', nil, nil, {}, 0) }

    it 'is never treated as the implicit global section' do
      expect(section.global?).to be(false)
      expect(section.is_global?).to be(false)
    end
  end

  describe 'empty-name metadata sections' do
    let(:tmpdir) { Dir.mktmpdir }
    let(:meta_file) { File.join(tmpdir, 'system', 'metadata', 'local.meta') }

    before do
      FileUtils.mkdir_p(File.dirname(meta_file))
      Puppet::Type.type(:splunk_config).new(
        name: 'config',
        server_confdir: tmpdir,
        forwarder_confdir: tmpdir,
      ).generate
    end

    after do
      FileUtils.remove_entry(tmpdir)
    end

    it 'writes a [] header for an empty section name' do
      resource = Puppet::Type.type(:splunk_metadata).new(
        title: 'system access',
        section: '',
        setting: 'access',
        value: 'read : [ * ], write : [ admin ]',
        context: 'system/local',
      )
      described_class.new(resource).create

      content = File.read(meta_file)
      expect(content).to match(%r{^\[\]$})
      expect(content).to include('access=read : [ * ], write : [ admin ]')
    end
  end
end
