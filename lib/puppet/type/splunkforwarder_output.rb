Puppet::Type.newtype(:splunkforwarder_output) do
  ensurable
  newparam(:name, :namevar => true) do
    desc 'Setting name to manage from outputs.conf'
  end
  newproperty(:value) do
    desc 'The value of the setting to be defined.'
    munge do |v|
      v.to_s.strip
    end
  end
  newproperty(:setting) do
    desc 'The setting being defined.'
    munge do |v|
      v.to_s.strip
    end
  end
  newproperty(:section) do
    desc 'The section the setting is defined under.'
    munge do |v|
      v.to_s.strip
    end
  end
end
