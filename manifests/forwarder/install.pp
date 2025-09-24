# @summary
#   Contains or define through additional platform specific sub-classes, the
#   steps for installing the Splunk Universal Forwarder
#
class splunk::forwarder::install {
  $_package_source = $splunk::forwarder::manage_package_source ? {
    true  => $splunk::forwarder::forwarder_package_src,
    false => $splunk::forwarder::package_source
  }

  if $splunk::forwarder::package_provider and !($splunk::forwarder::package_provider in ['apt','chocolatey','yum']) {
    $_src_package_filename = basename($_package_source)
    $_package_path_parts   = [$splunk::forwarder::staging_dir, $_src_package_filename]
    $_staged_package       = join($_package_path_parts, $splunk::forwarder::path_delimiter)

    archive { $_staged_package:
      source         => $_package_source,
      extract        => false,
      allow_insecure => $splunk::forwarder::allow_insecure,
      before         => Package[$splunk::forwarder::forwarder_package_name],
    }
  } else {
    $_staged_package = undef
  }

  Package {
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

  # Required for splunk from 7.2.4.2 until 8.0.0
  if (
    $splunk::params::manage_net_tools and
    $facts['kernel'] == 'Linux' and
    versioncmp($splunk::forwarder::version, '7.2.4.2') >= 0 and
    versioncmp($splunk::forwarder::version, '8.0.0') == -1
  ) {
    stdlib::ensure_packages(['net-tools'],
      {
        'ensure' => 'present',
      },
    )
    Package['net-tools'] -> Package[$splunk::forwarder::package_name]
  }

  package { $splunk::forwarder::package_name:
    ensure          => $splunk::forwarder::package_ensure,
    provider        => $splunk::forwarder::package_provider,
    install_options => $splunk::forwarder::install_options,
  }
}
