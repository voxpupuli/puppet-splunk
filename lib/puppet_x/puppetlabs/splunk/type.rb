# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '..', '..', 'voxpupuli/splunk/util')

module PuppetX
  module Puppetlabs
    module Splunk
      module Type
        def self.clone_type(type)
          type.ensurable

          type.define_singleton_method(:title_patterns) do
            [
              [%r{^([^/]*)$}, [[:section]]], # matches section titles without slashes, like 'tcpout:indexers'
              [%r{^(.*//.*)/(.*)$}, # matches section titles containing '//' and a setting,
               [ # like: 'monitor:///var/log/messages/index'
                 [:section], # where 'monitor:///var/log/messages' is the section
                 [:setting], # and 'index' is the setting.
               ],],
              [%r{^(.*//.*)$}, [[:section]]], # matches section titles containing '//', like 'tcp://127.0.0.1:19500'
              [%r{^(.*)/(.*)$}, # matches plain 'section/setting' titles, like: 'tcpout:indexers/server'
               [
                 [:section],
                 [:setting],
               ],],
            ]
          end
          type.newproperty(:value) do
            desc 'The value of the setting to be defined.'
            munge do |v|
              v.to_s.strip
            end
            def insync?(is) # rubocop:disable Lint/NestedMethodDefinition
              secrets_file_path = File.join(provider.class.file_path, 'auth/splunk.secret')
              secrets_file_exist = File.file?(secrets_file_path)

              current_values = normalize_values(is, secrets_file_path, secrets_file_exist)
              desired_values = normalize_values(should, secrets_file_path, false)

              current_values == desired_values
            end

            def normalize_values(value, secrets_file_path, secrets_file_exist) # rubocop:disable Lint/NestedMethodDefinition
              Array(value).map do |v|
                if !should.start_with?('$7$') && v.is_a?(String) && secrets_file_exist
                  PuppetX::Voxpupuli::Splunk::Util.decrypt(secrets_file_path, v)
                else
                  v
                end
              end
            end
          end
          type.newparam(:setting) do
            desc 'The setting being defined.'
            isnamevar
            munge do |v|
              v.to_s.strip
            end
          end
          type.newparam(:section) do
            desc 'The section the setting is defined under.'
            isnamevar
            munge do |v|
              v.to_s.strip
            end
          end
          type.newparam(:context) do
            desc 'The context in which to define the setting.'
            isnamevar
            munge do |v|
              v.to_s.strip
            end
            defaultto('system/local')
          end
          type.newparam(:name)
        end
      end
    end
  end
end
