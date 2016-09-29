require 'spec_helper'
#  The majority of splunk and splunkforwarder types are identical and inherit
#  the same functionality off ini_file, so we don't need individual tests for them

SPLUNK_TYPES.each do |type, file_name|
  describe Puppet::Type.type(type) do
    context 'attributes' do
      [:name, :setting, :section].each do |parameter|
        describe parameter.to_s do
          it 'has a name attribute' do
            expect(described_class.attrclass(parameter)).not_to be_nil
          end

          it 'is a parameter' do
            expect(described_class.attrtype(parameter)).to eq(:param)
          end
        end
      end

      it 'has a setting property' do
        expect(described_class.attrclass(:setting)).not_to be_nil
        expect(described_class.attrtype(:setting)).to eq(:param)
      end

      it 'has setting and section as namevars' do
        expect(described_class.key_attributes.sort).to eq([:name, :section, :setting])
      end
    end

    context 'declaring the type' do
      it 'maps section/setting form the resource title to section' do
        type = described_class.new(title: 'foo/bar')
        expect(type[:section]).to eq('foo')
      end

      it 'maps section/setting form the resource title to setting' do
        type = described_class.new(title: 'foo/bar')
        expect(type[:setting]).to eq('bar')
      end

      it 'does not try and split URLs' do
        type = described_class.new(title: 'http://foo')
        expect(type[:section]).to eq('http://foo')
      end

      it 'ignores title when section is declared' do
        type = described_class.new(title: 'foo/bar', setting: 'tango', section: 'delta')
        expect(type[:section]).to eq('delta')
      end
      it 'ignores title when setting is declared' do
        type = described_class.new(title: 'foo/bar', setting: 'tango', setting: 'delta')
        expect(type[:setting]).to eq('delta')
      end
    end

    context 'provider' do
      it "has a file path of #{file_name}" do
        expect(described_class.provider(:ini_setting).file_name).to eq(file_name)
      end
    end
  end
end
