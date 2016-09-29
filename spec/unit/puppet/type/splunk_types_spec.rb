require 'spec_helper'
#  The majority of splunk and splunkforwarder types are identical and inherit
#  the same functionality off ini_file, so we don't need individual tests for them

SPLUNK_TYPES.each do |type, file_name|
  describe Puppet::Type.type(type) do

    context "attributes" do

      [ :name, :setting, :section ].each do |parameter|
        describe parameter.to_s do
          it "should have a name attribute" do
            expect(described_class.attrclass(parameter)).not_to be_nil
          end

          it "should be a parameter" do
            expect(described_class.attrtype(parameter)).to eq(:param)
          end
        end
      end

      it "should have a setting property" do
        expect(described_class.attrclass(:setting)).not_to be_nil
        expect(described_class.attrtype(:setting)).to eq(:param)
      end

      it "should have name setting and section as namevars" do
        expect(described_class.key_attributes.sort).to eq([:name, :section, :setting])
      end

    end

    context "declaring the type" do
      it "should map section/setting form the resource title" do
        type=described_class.new(:title => 'foo/bar')
        expect(type[:section]).to eq('foo')
        expect(type[:setting]).to eq('bar')
      end

      it "should not try and split URLs" do
        type=described_class.new(:title => 'http://foo')
        expect(type[:section]).to eq('http://foo')
      end

      it "should ignore title when section and setting are declared" do
        type=described_class.new(:title => 'foo/bar', :setting => 'tango', :section => 'delta')
        expect(type[:section]).to eq('delta')
        expect(type[:setting]).to eq('tango')
      end
    end

    context "provider" do
      it "should have a file path of #{file_name}" do
        expect(described_class.provider(:ini_setting).file_name).to eq(file_name)
      end
    end
  end
end
