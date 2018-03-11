module PuppetX
  module Puppetlabs
    module Splunk
      module Type
        def self.clone_type(type)
          type.ensurable

          type.define_singleton_method(:title_patterns) do
            [
              [%r{^([^\/]*)$}, [[:section]]],   # matches section titles without slashes, like 'tcpout:indexers'
              [%r{^(.*\/\/.*)\/(.*)$},          # matches section titles containing '//' and a setting,
               [                                # like: 'monitor:///var/log/messages/index'
                 [:section],       # where 'monitor:///var/log/messages' is the section
                 [:setting]        # and 'index' is the setting.
               ]],
              [%r{^(.*\/\/.*)$}, [[:section]]], # matches section titles containing '//', like 'tcp://127.0.0.1:19500'
              [%r{^(.*)\/(.*)$},                # matches plain 'section/setting' titles, like: 'tcpout:indexers/server'
               [
                 [:section],
                 [:setting]
               ]]
            ]
          end
          type.newproperty(:value) do
            desc 'The value of the setting to be defined.'
            munge do |v|
              v.to_s.strip
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
