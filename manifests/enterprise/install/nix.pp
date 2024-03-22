# @summary
#   Private class declared by Class[splunk::enterprise::install] to provide
#   platform specific installation steps on Linux or Unix type systems.
#
class splunk::enterprise::install::nix inherits splunk::enterprise::install {
  if $facts['kernel'] == 'SunOS' {
    $_responsefile = "${splunk::enterprise::staging_dir}/response.txt"
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
    Package[$splunk::enterprise::enterprise_package_name] {
      adminfile    => $_adminfile,
      responsefile => $_responsefile,
    }
  }

  # Required for splunk from 7.2.4.2 until 8.0.0
  if (
    $splunk::params::manage_net_tools and
    $facts['kernel'] == 'Linux' and
    versioncmp($splunk::enterprise::version, '7.2.4.2') >= 0 and
    versioncmp($splunk::enterprise::version, '8.0.0') == -1
  ) {
    stdlib::ensure_packages(['net-tools'], {
        'ensure' => 'present',
    })
    Package['net-tools'] -> Package[$splunk::enterprise::enterprise_package_name]
  }
}
