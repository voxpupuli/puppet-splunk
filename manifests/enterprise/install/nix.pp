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

  # Required for splunk 7.2.4.2
  if versioncmp($splunk::enterprise::version, '7.2.4.2') >= 0 {
    ensure_packages(['net-tools'], {
      'ensure' => 'present',
      before   => Package[$splunk::enterprise::enterprise_package_name]
    })
  }

}
