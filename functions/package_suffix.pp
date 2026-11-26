# @summary
#   Builds the version/build-specific tail end of a Splunk package file name
#   (everything after `splunk-`/`splunkforwarder-`) for a given OS family and
#   architecture.
#
# @api private
function splunk::package_suffix(
  String[1] $os_family,
  String[1] $architecture,
  String[1] $version,
  String[1] $build,
) >> String[1] {
  # Download URLs changed starting from 9.4.0 for debs.
  # Splunk only includes "-linux-".
  $deb_prefix = versioncmp($version, '9.4.0') >= 0 ? {
    true    => 'linux',
    default => 'linux-2.6',
  }

  # Download URLs changed starting from 8.2.11 and 9.0.5 for RPMs.
  # Splunk no longer includes "-linux-2.6-".
  $linux_prefix = (versioncmp($version, '9.0.5') >= 0 or (versioncmp($version, '8.2.11') >= 0 and versioncmp($version, '9.0.0') == -1)) ? {
    true    => '.',
    default => '-linux-2.6-',
  }

  case "${os_family} ${architecture}" {
    'RedHat i386': {
      "${version}-${build}.i386.rpm"
    }
    'RedHat x86_64', 'Suse x86_64': {
      "${version}-${build}${linux_prefix}x86_64.rpm"
    }
    'RedHat ppc64le': {
      "${version}-${build}${linux_prefix}ppc64le.rpm"
    }
    'RedHat aarch64': {
      "${version}-${build}${linux_prefix}aarch64.rpm"
    }
    'Debian i386': {
      "${version}-${build}-linux-2.6-intel.deb"
    }
    'Debian amd64': {
      "${version}-${build}-${deb_prefix}-amd64.deb"
    }
    'Debian aarch64': {
      versioncmp($version, '9.4.0') >= 0 ? {
        true    => "${version}-${build}-linux-arm64.deb",
        default => "${version}-${build}-Linux-armv8.deb",
      }
    }
    /^(W|w)indows (x86|i386)$/: {
      "${version}-${build}-windows-x86.msi"
    }
    /^(W|w)indows (x64|x86_64)$/: {
      "${version}-${build}-windows-x64.msi"
    }
    'Solaris i86pc': {
      "${version}-${build}-solaris-10-intel.pkg"
    }
    'Solaris sun4v': {
      "${version}-${build}-solaris-8-sparc.pkg"
    }
    'FreeBSD amd64': {
      "${version}-${build}-freebsd-11.1-amd64.txz"
    }
    default: {
      fail("unsupported osfamily/arch ${os_family}/${architecture}")
    }
  }
}
