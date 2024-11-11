# @summary
#   Private class declared by Class[splunk::edgeprocessor] to contain the required steps
#   for successfully installing the Splunk Edge Processor
#
class splunk::edgeprocessor::install (
  String[1] $archive_name = regsubst($splunk::edgeprocessor::package_url, '([^\/]+\.tar\.gz)$', '\\1'),
) {
  #Download and unpack the Splunk Edge Processor
  archive { $splunk::edgeprocessor::archive_name:
    path          => "/tmp/${archive_name}",
    source        => $splunk::edgeprocessor::package_url,
    checksum      => $splunk::edgeprocessor::splunk_package_checksum,
    checksum_type => $splunk::edgeprocessor::checksum_type,
    extract       => true,
    extract_path  => "${splunk::edgeprocessor::splunk_homedir}/..",
    creates       => $splunk::edgeprocessor::splunk_homedir,
    cleanup       => true,
    user          => $splunk::edgeprocessor::splunk_user,
    group         => $splunk::edgeprocessor::splunk_user,
  }
  file { "${splunk::edgeprocessor::splunk_homedir}/var/log":
    ensure => directory,
    owner  => $splunk::edgeprocessor::splunk_user,
    group  => $splunk::edgeprocessor::splunk_user,
  }
}
