# frozen_string_literal: true

require 'openssl'
require 'base64'

module PuppetX
  module Voxpupuli
    module Splunk
      class Util
        def self.decrypt(secrets_file, value)
          return value unless value.is_a?(String)

          if value.start_with?('$7$')
            decrypt_v7(secrets_file, value)
          elsif value.start_with?('$8$')
            decrypt_v8(secrets_file, value)
          else
            value
          end
        end

        def self.decrypt_v7(secrets_file, value)
          Puppet.debug "Decrypting splunk >= 7.2 data using secret from #{secrets_file}"
          data = Base64.strict_decode64(value[3..-1])
          splunk_secret = File.binread(secrets_file).chomp

          key = OpenSSL::PKCS5.pbkdf2_hmac(splunk_secret, 'disk-encryption', 1, 32, OpenSSL::Digest.new('SHA256'))
          decrypt_gcm(key, data)
        end
        private_class_method :decrypt_v7

        def self.decrypt_v8(secrets_file, value)
          Puppet.debug "Decrypting splunk >= 10.6 data using secret from #{secrets_file}"
          # format: $8$<base64 salt>$<base64 iv+ciphertext+tag>
          _, _, b64_salt, b64_payload = value.split('$', 4)
          splunk_secret = File.binread(secrets_file).chomp

          key = OpenSSL::KDF.hkdf(
            splunk_secret,
            salt: Base64.strict_decode64(b64_salt),
            info: 'disk-encryption-hkdf',
            length: 32,
            hash: 'SHA256',
          )
          decrypt_gcm(key, Base64.strict_decode64(b64_payload))
        end
        private_class_method :decrypt_v8

        def self.decrypt_gcm(key, data)
          iv         = data.bytes[0, 16].pack('c*')
          tag        = data.bytes[-16..-1].pack('c*')
          ciphertext = data.bytes[16..-17].pack('c*')

          decipher = OpenSSL::Cipher.new('aes-256-gcm').decrypt
          decipher.key = key
          decipher.iv_len = 16
          decipher.iv = iv
          decipher.auth_tag = tag
          decipher.auth_data = ''

          decipher.update(ciphertext) + decipher.final
        end
        private_class_method :decrypt_gcm
      end
    end
  end
end
