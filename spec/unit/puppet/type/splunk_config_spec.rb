require 'spec_helper'

describe Puppet::Type.type(:splunk_config) do

  let(:subject) {
    described_class.new(
      :name => "config",
      :server_confdir => '/opt/splunk/etc',
      :forwarder_confdir => '/opt/splunkforwarder/etc')
  }

  describe "generate" do
    before do
      subject.generate
    end

    # These tests make sure that the generate method of the splunk_config
    # type correctly sets the class instance variables for each splunk
    # type with the correct file path.
    #
    SPLUNK_TYPES.each do |type, file_name|
      if SPLUNK_SERVER_TYPES.has_key?(type)
        file_path = File.join('/opt/splunk/etc', file_name)
      elsif SPLUNK_FORWARDER_TYPES.has_key?(type)
        file_path = File.join('/opt/splunkforwarder/etc', file_name)
      end

      it "should configure the #{type} type with file path #{file_path}" do
        provider = Puppet::Type.type(type).provider(:ini_setting)
        expect(provider.file_path).to eq(file_path)
      end
    end
  end
end
