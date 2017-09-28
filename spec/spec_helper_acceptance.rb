require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'
require 'splunk_data.rb'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_module
install_module_dependencies

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Need to stage the Splunk/Splunkforwarder packages here.
  end
end
