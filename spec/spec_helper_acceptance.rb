require 'beaker-rspec'
require 'pry'

RSpec.configure do |c|
  c.tty = true
  c.formatter = :documentation

  c.before :suite do
    module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
    puppet_module_install(source: module_root, module_name: 'splunk')

    hosts.each do |host|
      on host, puppet('module', 'install', 'nanliu-staging', '--version', '0.3.1'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version', '3.0.0'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-inifile', '--version', '1.0.0'), acceptable_exit_codes: [0, 1]
    end
  end
end
