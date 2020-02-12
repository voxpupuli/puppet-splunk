require 'spec_helper'
#  The majority of splunk and splunkforwarder types are identical and inherit
#  the same functionality off ini_file, so we don't need individual tests for them

SPLUNK_TYPES.each do |type, file_name|
  describe Puppet::Type.type(type) do
    context 'attributes' do
      [:name, :setting, :section, :context].each do |parameter|
        describe parameter.to_s do
          it 'has a name attribute' do
            expect(described_class.attrclass(parameter)).not_to be_nil
          end

          it 'is a parameter' do
            expect(described_class.attrtype(parameter)).to eq(:param)
          end
        end
      end

      it 'has a setting attribute' do
        expect(described_class.attrclass(:setting)).not_to be_nil
      end

      it 'specifies setting as a parameter' do
        expect(described_class.attrtype(:setting)).to eq(:param)
      end

      it 'has name, context, setting and section as namevars' do
        expect(described_class.key_attributes.sort).to eq([:context, :name, :section, :setting])
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

      it 'does not try and split simple URLs' do
        type = described_class.new(title: 'http://foo')
        expect(type[:section]).to eq('http://foo')
      end

      it 'splits more complicated URL-like patterns' do
        type = described_class.new(title: 'monitor:///var/log/foo/index')
        expect(type[:section]).to eq('monitor:///var/log/foo')
      end

      it 'splits more complicated URL-like patterns' do
        type = described_class.new(title: 'monitor:///var/log/foo/index')
        expect(type[:setting]).to eq('index')
      end

      it 'ignores title when section is declared' do
        type = described_class.new(title: 'foo/bar', setting: 'tango', section: 'delta')
        expect(type[:section]).to eq('delta')
      end
      it 'ignores title when setting is declared' do
        type = described_class.new(title: 'foo/bar', setting: 'tango', section: 'delta')
        expect(type[:setting]).to eq('tango')
      end
    end

    context 'provider' do
      it "has a file path of #{file_name}" do
        expect(described_class.provider(:ini_setting).file_name).to eq(file_name)
      end
    end

    describe 'value property' do
      it 'has a value property' do
        expect(described_class.attrtype(:value)).to eq(:property)
      end
      context 'when testing value is insync' do
        let(:resource) { described_class.new(title: 'foo/bar', value: 'value') }
        let(:property) { resource.property(:value) }

        before do
          Puppet::Type.type(:splunk_config).new(
            name: 'config',
            server_confdir: '/opt/splunk/etc',
            forwarder_confdir: '/opt/splunkforwarder/etc'
          ).generate
        end

        it 'is insync if unencrypted `is` value matches `should` value' do
          property.should = 'value'
          expect(property).to be_safe_insync('value')
        end
        it 'is insync if encrypted `is` value matches `should` value after being decrypted' do
          property.should = 'temp1234'
          allow(File).to receive(:file?).with(%r{/opt/splunk(forwarder)?/etc/auth/splunk\.secret$}).and_return(true)
          allow(IO).to receive(:binread).with(%r{/opt/splunk(forwarder)?/etc/auth/splunk\.secret$}).and_return('JX7cQAnH6Nznmild8MvfN8/BLQnGr8C3UYg3mqvc3ArFkaxj4gUt1RUCaRBD/r0CNn8xOA2oKX8/0uyyChyGRiFKhp6h2FA+ydNIRnN46N8rZov8QGkchmebZa5GAM5U50GbCCgzJFObPyWi5yT8CrSCYmv9cpRtpKyiX+wkhJwltoJzAxWbBERiLp+oXZnN3lsRn6YkljmYBqN9tZLTVVpsLvqvkezPgpv727Fd//5dRoWsWBv2zRp0mwDv3tj')
          expect(property).to be_safe_insync('$7$aTVkS01HYVNJUk5wSnR5NIu4GXLhj2Qd49n2B6Y8qmA/u1CdL9JYxQ==')
        end
      end
    end
  end
end
