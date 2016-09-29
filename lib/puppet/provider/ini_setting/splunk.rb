Puppet::Type.type(:ini_setting).provide(
  :splunk,
  parent: Puppet::Type.type(:ini_setting).provider(:ruby)
) do

  confine true: false # Never automatically select this provider

  @file_path = nil

  class << self
    attr_writer :file_path
  end

  def self.file_path
    raise Puppet::Error, 'file_path must be set with splunk_config type before provider can be used' if @file_path.nil?
    raise Puppet::Error, 'Child provider class does not support a file_name method' unless respond_to?(:file_name)
    File.join(@file_path, file_name)
  end
end
