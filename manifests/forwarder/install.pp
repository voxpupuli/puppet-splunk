# @summary
#   Private class declared by Class[splunk::forwarder] to contain or define
#   through additional platform specific sub-class, the required steps
#   for successfully installing the Splunk Universal Forwarder
#
class splunk::forwarder::install {
  assert_private()

  # Determine the managed Splunk package_source
  case "${facts['os']['family']} ${facts['architecture']}" {
    'RedHat i386'                : { $_package_suffix = "${splunk::forwarder::_version}-${splunk::forwarder::_build}.i386.rpm" }
    'RedHat x86_64'              : { $_package_suffix = "${splunk::forwarder::_version}-${splunk::forwarder::_build}-linux-2.6-x86_64.rpm" }
    'Debian i386'                : { $_package_suffix = "${splunk::forwarder::_version}-${splunk::forwarder::_build}-linux-2.6-intel.deb" }
    'Debian amd64'               : { $_package_suffix = "${splunk::forwarder::_version}-${splunk::forwarder::_build}-linux-2.6-amd64.deb" }
    /^(W|w)indows (x86|i386)$/   : { $_package_suffix = "${splunk::forwarder::_version}-${splunk::forwarder::_build}-x86-release.msi" }
    /^(W|w)indows (x64|x86_64)$/ : { $_package_suffix = "${splunk::forwarder::_version}-${splunk::forwarder::_build}-x64-release.msi" }
    'Solaris i86pc'              : { $_package_suffix = "${splunk::forwarder::_version}-${splunk::forwarder::_build}-solaris-10-intel.pkg" }
    'Solaris sun4v'              : { $_package_suffix = "${splunk::forwarder::_version}-${splunk::forwarder::_build}-solaris-8-sparc.pkg" }
    default                      : { fail("unsupported osfamily/arch ${facts['os']['family']}/${facts['architecture']}") }
  }
  $_managed_package_source = pick($splunk::forwarder::managed_package_source,"${splunk::forwarder::src_root}/products/splunk/releases/${splunk::forwarder::_version}/${splunk::forwarder::src_subdir}/${splunk::forwarder::package_name}-${_package_suffix}")

  $_package_source = $splunk::forwarder::manage_package_source ? {
    true  => $_managed_package_source,
    false => $splunk::forwarder::unmanaged_package_source
  }

  if $splunk::forwarder::package_provider and !($splunk::forwarder::package_provider in ['apt','chocolatey','yum']) {
    $_src_package_filename = basename($_package_source)
    $_package_path_parts   = [$splunk::forwarder::staging_dir, $_src_package_filename]
    $_staged_package       = join($_package_path_parts, $splunk::forwarder::path_delimiter)

    archive { $_staged_package:
      source  => $_package_source,
      extract => false,
      before  => Package[$splunk::forwarder::package_name],
    }
  } else {
    $_staged_package = undef
  }

  Package  {
    source         => $splunk::forwarder::package_provider ? {
      'chocolatey' => undef,
      default      => $splunk::forwarder::manage_package_source ? {
        true  => pick($_staged_package, $_package_source),
        false => $_package_source,
      }
    },
  }

  if $facts['kernel'] == 'SunOS' {
    $_responsefile = "${splunk::forwarder::staging_dir}/response.txt"
    $_adminfile    = '/var/sadm/install/admin/splunk-noask'

    file { 'splunk_adminfile':
      ensure => file,
      path   => $_adminfile,
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/splunk/splunk-noask',
    }

    file { 'splunk_pkg_response_file':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      path    => $_responsefile,
      content => "BASEDIR=/opt\n",
    }

    # Collect any Splunk packages and give them an admin and response file.
    Package {
      adminfile    => $_adminfile,
      responsefile => $_responsefile,
    }
  }

  # Required for splunk 7.2.4.2
  if ($facts['kernel'] == 'Linux' or $facts['kernel'] == 'SunOS') and (versioncmp($splunk::forwarder::_version, '7.2.4.2') >= 0) {
    ensure_packages(['net-tools'], {
      'ensure' => 'present',
      before   => Package[$splunk::forwarder::package_name]
    })
  }

  # Dpkg and sun are not versionable, and will utilize the source as the
  # version
  if $splunk::forwarder::package_provider in ['dpkg','sun'] {
    $_package_ensure = pick($splunk::forwarder::package_ensure, 'installed')
  }
  else {
    $_package_ensure = pick($splunk::forwarder::package_ensure, "${splunk::forwarder::_version}-${splunk::forwarder::_build}")
  }

  package { $splunk::forwarder::package_name:
    ensure          => $_package_ensure,
    provider        => $splunk::forwarder::package_provider,
    install_options => $splunk::forwarder::install_options,
  }

}
