require 'spec_helper'

describe 'splunkforwarder_version Fact' do
  before do
    Facter.clear
  end

  it 'returns version for Windows' do
    allow(File).to receive(:exist?).with('C:/Program Files/SplunkUniversalForwarder/bin/splunk.exe').and_return(true)
    allow(Facter::Util::Resolution).to receive(:exec).with('"C:/Program Files/SplunkUniversalForwarder/bin/splunk.exe" --version').and_return('Splunk Universal Forwarder 7.0.2 (build 03bbabbd5c0f)')
    expect(Facter.fact(:splunkforwarder_version).value).to eq('7.0.2')
  end

  it 'returns version for Linux' do
    allow(File).to receive(:exist?).with('C:/Program Files/SplunkUniversalForwarder/bin/splunk.exe').and_return(false)
    allow(File).to receive(:exist?).with('/opt/splunkforwarder/bin/splunk').and_return(true)
    allow(Facter::Util::Resolution).to receive(:exec).with('/opt/splunkforwarder/bin/splunk --version').and_return('Splunk Universal Forwarder 7.0.2 (build 03bbabbd5c0f)')
    expect(Facter.fact(:splunkforwarder_version).value).to eq('7.0.2')
  end

  it 'returns nil' do
    allow(File).to receive(:exist?).with('C:/Program Files/SplunkUniversalForwarder/bin/splunk.exe').and_return(false)
    allow(File).to receive(:exist?).with('/opt/splunkforwarder/bin/splunk').and_return(false)
    expect(Facter.fact(:splunkforwarder_version).value).to be_nil
  end
end
