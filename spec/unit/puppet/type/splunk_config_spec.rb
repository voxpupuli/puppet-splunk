require 'spec_helper'

describe Puppet::Type.type(:splunk_config) do
  let(:subject) do
    described_class.new(
      name: 'config',
      server_confdir: '/opt/splunk/etc',
      forwarder_confdir: '/opt/splunkforwarder/etc'
    )
  end

  describe 'generate' do
    before do
      subject.generate
    end

    # These tests make sure that the generate method of the splunk_config
    # type correctly sets the class instance variables for each splunk
    # type with the correct file path.
    #
    SPLUNK_TYPES.each do |type, file_name|
      if SPLUNK_SERVER_TYPES.key?(type)
        context = type == :splunk_metadata ? 'metadata' : 'local'
        file_path = File.join('/opt/splunk/etc/system', context, file_name)
      elsif SPLUNK_FORWARDER_TYPES.key?(type)
        file_path = File.join('/opt/splunkforwarder/etc/system/local', file_name)
      end

      it "should configure the #{type} type with file path #{file_path}" do
        resource = Puppet::Type.type(type).new(name: 'foo', setting: 'foo', section: 'foo')
        provider = Puppet::Type.type(type).provider(:ini_setting).new(resource)
        expect(provider.file_path).to eq(file_path)
      end
    end
  end
end
