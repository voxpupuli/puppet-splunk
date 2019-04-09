require 'spec_helper'
require 'puppet_x/voxpupuli/splunk/util'

describe PuppetX::Voxpupuli::Splunk::Util do
  describe '.decrypt' do
    context 'when called with an unencrypted value' do
      it 'returns the value unmodified' do
        expect(described_class.decrypt('secrets_file', 'non_encrypted_value')).to eq 'non_encrypted_value'
      end
    end
    context 'when called with splunk 7.2 encrypted value' do
      let(:encrypted_value) { '$7$aTVkS01HYVNJUk5wSnR5NIu4GXLhj2Qd49n2B6Y8qmA/u1CdL9JYxQ==' }
      let(:splunk_secret) { 'JX7cQAnH6Nznmild8MvfN8/BLQnGr8C3UYg3mqvc3ArFkaxj4gUt1RUCaRBD/r0CNn8xOA2oKX8/0uyyChyGRiFKhp6h2FA+ydNIRnN46N8rZov8QGkchmebZa5GAM5U50GbCCgzJFObPyWi5yT8CrSCYmv9cpRtpKyiX+wkhJwltoJzAxWbBERiLp+oXZnN3lsRn6YkljmYBqN9tZLTVVpsLvqvkezPgpv727Fd//5dRoWsWBv2zRp0mwDv3tj' }

      it 'returns decrypted value' do
        allow(IO).to receive(:binread).with('secrets_file').and_return(splunk_secret)
        expect(described_class.decrypt('secrets_file', encrypted_value)).to eq 'temp1234'
      end
    end
  end
end
