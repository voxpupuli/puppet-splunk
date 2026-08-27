# frozen_string_literal: true

# Load Puppet::Util::IniFile via puppetlabs-inifile's own provider.
# Do not `require 'puppet/util/ini_file'` - that file lives in another module
# and is not on $LOAD_PATH under Puppet Server module isolation (inifile 6.x).
# See https://github.com/voxpupuli/puppet-splunk/issues/239
ini_setting = Puppet::Type.type(:ini_setting)
raise LoadError, 'puppetlabs-inifile is required to load splunk_metadata' unless ini_setting

ini_setting.provider(:ruby)
raise LoadError, 'puppetlabs-inifile did not load Puppet::Util::IniFile' unless defined?(Puppet::Util::IniFile)

class SectionNoGlobal < Puppet::Util::IniFile::Section
  def initialize(model)
    super(model.name, model.start_line, model.end_line,
      model.instance_variable_get(:@existing_settings),
      model.indentation)
  end

  # this section is never global, allowing for sections with an empty name ([])
  def global?
    false
  end
  alias is_global? global?
end

class IniFileNoGlobal < Puppet::Util::IniFile
  def parse_file
    super

    # We do not need a global section but allow one with an empty name.
    # parse_file always adds the former which will get overwritten by the
    # latter (if it exists) but will add '' to the section_names array twice.
    @section_names = @section_names.uniq
  end

  def add_section(section)
    super(SectionNoGlobal.new(section))
  end
end

Puppet::Type.type(:splunk_metadata).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:splunk),
) do
  def self.file_name
    'local.meta'
  end

  def file_path
    context = resource[:context]
    file_name = self.class.file_name

    # redirect context and file name for metadata
    # {app/foo,system}/{default,local} -> {app/foo,system}/metadata/{default,local}.meta
    ctxelem = File.split(context)
    if %w[local default].include?(ctxelem[-1])
      file_name = "#{ctxelem[-1]}.meta"
      context = File.join(ctxelem[0..-2], 'metadata')
    end

    File.join(self.class.file_path, context, file_name)
  end

  def ini_file
    @ini_file ||= IniFileNoGlobal.new(file_path, separator, section_prefix, section_suffix, indent_char, indent_width)
  end
end
