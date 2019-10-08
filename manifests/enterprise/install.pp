# @summary
#   Private class declared by Class[splunk::enterprise] to contain or define
#   through additional platform specific sub-class, the required steps
#   for successfully installing Splunk Enterprise
#
class splunk::enterprise::install {
  assert_private()

  if $facts['kernel'] == 'Linux' or $facts['kernel'] == 'SunOS' {
    include splunk::enterprise::install::nix
  }

  # Determine the managed Splunk package_source
  case "${facts['os']['family']} ${facts['architecture']}" {
    'RedHat i386'                : { $_package_suffix = "${splunk::enterprise::_version}-${splunk::enterprise::_build}.i386.rpm" }
    'RedHat x86_64'              : { $_package_suffix = "${splunk::enterprise::_version}-${splunk::enterprise::_build}-linux-2.6-x86_64.rpm" }
    'Debian i386'                : { $_package_suffix = "${splunk::enterprise::_version}-${splunk::enterprise::_build}-linux-2.6-intel.deb" }
    'Debian amd64'               : { $_package_suffix = "${splunk::enterprise::_version}-${splunk::enterprise::_build}-linux-2.6-amd64.deb" }
    /^(W|w)indows (x86|i386)$/   : { $_package_suffix = "${splunk::enterprise::_version}-${splunk::enterprise::_build}-x86-release.msi" }
    /^(W|w)indows (x64|x86_64)$/ : { $_package_suffix = "${splunk::enterprise::_version}-${splunk::enterprise::_build}-x64-release.msi" }
    'Solaris i86pc'              : { $_package_suffix = "${splunk::enterprise::_version}-${splunk::enterprise::_build}-solaris-10-intel.pkg" }
    'Solaris sun4v'              : { $_package_suffix = "${splunk::enterprise::_version}-${splunk::enterprise::_build}-solaris-8-sparc.pkg" }
    default                      : { fail("unsupported osfamily/arch ${facts['os']['family']}/${facts['architecture']}") }
  }
  $_managed_package_source = pick($splunk::enterprise::managed_package_source,"${splunk::enterprise::src_root}/products/splunk/releases/${splunk::enterprise::_version}/${splunk::enterprise::src_subdir}/${splunk::enterprise::package_name}-${_package_suffix}")


  $_package_source = $splunk::enterprise::manage_package_source ? {
    true  => $_managed_package_source,
    false => $splunk::enterprise::unmanaged_package_source
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
  }
  else {
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

  # Dpkg and sun are not versionable, and will utilize the source as the
  # version
  if $splunk::enterprise::package_provider in ['dpkg','sun'] {
    $_package_ensure = pick($splunk::enterprise::package_ensure, 'installed')
  }
  else {
    $_package_ensure = pick($splunk::enterprise::package_ensure, "${splunk::enterprise::_version}-${splunk::enterprise::_build}")
  }

  package { $splunk::enterprise::package_name:
    ensure          => $_package_ensure,
    provider        => $splunk::enterprise::package_provider,
    install_options => $splunk::enterprise::install_options,
  }

}
