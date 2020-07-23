require 'spec_helper'

describe 'splunkforwarder_version Fact' do
  before do
    Facter.clear
  end

  it 'returns version for Windows' do
    allow(Facter).to receive(:value).with(':kernel').and_return("windows")
    allow(File).to receive(:exist?).with('C:/Program Files/SplunkUniversalForwarder/etc/splunk.version').and_return(true)
    allow(open).with('C:/Program Files/Splunk/etc/splunk.version').to receive(read).and_return('Splunk 6.6.8 (build 6c27a8439c1e)')
    expect(Facter.fact(:splunkforwarder_version).value).to eq('6.6.8')
  end

  it 'returns version for Linux' do
    allow(Facter).to receive(:value).with(':kernel').and_return("Linux")
    allow(File).to receive(:exist?).with('/opt/splunkforwarder/etc/splunk.version').and_return(true)
    allow(open).with('/opt/splunkforwarder/etc/splunk.version').to receive(read).and_return('Splunk 6.6.8 (build 6c27a8439c1e)')
    expect(Facter.fact(:splunkforwarder_version).value).to eq('6.6.8')
  end

  it 'returns nil' do
    allow(Facter).to receive(:value).with(':kernel').and_return("Linux")
    allow(File).to receive(:exist?).with('/opt/splunkforwarder/etc/splunk.version').and_return(false)
    expect(Facter.fact(:splunkforwarder_version).value).to be_nil
  end
end
