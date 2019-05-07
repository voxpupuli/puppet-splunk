require 'openssl'
require 'base64'

module PuppetX
  module Voxpupuli
    module Splunk
      class Util
        def self.decrypt(secrets_file, value)
          return value unless value.start_with?('$7$')

          Puppet.debug "Decrypting splunk >= 7.2 data using secret from #{secrets_file}"
          value.slice!(0, 3)
          data = Base64.strict_decode64(value)
          splunk_secret = IO.binread(secrets_file).chomp

          iv         = data.bytes[0, 16].pack('c*')
          tag        = data.bytes[-16..-1].pack('c*')
          ciphertext = data.bytes[16..-17].pack('c*')

          decipher = OpenSSL::Cipher::AES.new(256, :GCM).decrypt
          decipher.key = OpenSSL::PKCS5.pbkdf2_hmac(splunk_secret, 'disk-encryption', 1, 32, OpenSSL::Digest::SHA256.new)
          decipher.iv_len = 16
          decipher.iv = iv
          decipher.auth_tag = tag
          decipher.auth_data = ''

          decipher.update(ciphertext) + decipher.final
        end
      end
    end
  end
end
