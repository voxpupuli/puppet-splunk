# @summary
#   Private class declared by Class[splunk::enterprise] to contain or define
#   through additional platform specific sub-class, the required steps
#   for successfully installing Splunk Enterprise
#
class splunk::enterprise::install {

  if $facts['kernel'] == 'Linux' or $facts['kernel'] == 'SunOS' {
    include splunk::enterprise::install::nix
  }

  $_package_source = $splunk::enterprise::manage_package_source ? {
    true  => $splunk::enterprise::enterprise_package_src,
    false => $splunk::enterprise::package_source
  }

  if $splunk::enterprise::package_provider and !($splunk::enterprise::package_provider in ['apt','chocolatey','yum']) {
    $_src_package_filename = basename($_package_source)
    $_package_path_parts   = [$splunk::enterprise::staging_dir, $_src_package_filename]
    $_staged_package       = join($_package_path_parts, $splunk::enterprise::path_delimiter)

    archive { $_staged_package:
      source  => $_package_source,
      extract => false,
      before  => Package[$splunk::enterprise::package_name],
    }
  } else {
    $_staged_package = undef
  }

  Package  {
    source         => $splunk::enterprise::package_provider ? {
      'chocolatey' => undef,
      default      => $splunk::enterprise::manage_package_source ? {
        true  => pick($_staged_package, $_package_source),
        false => $_package_source,
      }
    },
  }

  package { $splunk::enterprise::package_name:
    ensure          => $splunk::enterprise::package_ensure,
    provider        => $splunk::enterprise::package_provider,
    install_options => $splunk::enterprise::install_options,
  }

}
