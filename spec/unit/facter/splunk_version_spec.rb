require 'spec_helper'

describe 'splunk_version Fact' do
  before do
    Facter.clear
  end

  it 'returns version for Windows' do
    allow(File).to receive(:exist?).with('C:/Program Files/Splunk/bin/splunk.exe').and_return(true)
    allow(Facter::Util::Resolution).to receive(:exec).with('"C:/Program Files/Splunk/bin/splunk.exe" --version').and_return('Splunk 6.6.8 (build 6c27a8439c1e)')
    expect(Facter.fact(:splunk_version).value).to eq('6.6.8')
  end

  it 'returns version for Linux' do
    allow(File).to receive(:exist?).with('C:/Program Files/Splunk/bin/splunk.exe').and_return(false)
    allow(File).to receive(:exist?).with('/opt/splunk/bin/splunk').and_return(true)
    allow(Facter::Util::Resolution).to receive(:exec).with('/opt/splunk/bin/splunk --version').and_return('Splunk 6.6.8 (build 6c27a8439c1e)')
    expect(Facter.fact(:splunk_version).value).to eq('6.6.8')
  end

  it 'returns nil' do
    allow(File).to receive(:exist?).with('C:/Program Files/Splunk/bin/splunk.exe').and_return(false)
    allow(File).to receive(:exist?).with('/opt/splunk/bin/splunk').and_return(false)
    expect(Facter.fact(:splunk_version).value).to be_nil
  end
end
