# @summary
#   Install and configure an instance of Splunk Edge Processor. This module assumes you're using systemd.
#
# @example Basic usage
#   include splunk::edgeprocessor
#
# @param splunk_user
#   The user to run Splunk as
#
# @param package_url
#   URL to download the Edge Processor from, expected as a tar.gz file.
# 
# @param validate_package_checksum
#   Boolean, will skip checksum validation of downloaded package if False
#
# @param checksum_type
#   none|md5|sha1|sha2|sha256|sha384|sha512
#
# @param splunk_package_checksum
#   Checksum of archive package provided by Splunk
#
# @param splunk_homedir
#   Directory to install Splunk Edge Processor
#
# @param scs_group_id
#   Splunk Cloud Service Edge Processor cluster ID
class splunk::edgeprocessor (
  String[1] $splunk_user = $splunk::params::splunk_user,
  Stdlib::HTTPSUrl $package_url = $splunk::params::edgeproc_package_src,
  Boolean $validate_package_checksum = true,
  String[1] $checksum_type = $splunk::params::edgeproc_package_checksum_type,
  String[1] $splunk_package_checksum = $splunk::params::edgeproc_package_checksum,
  Stdlib::UnixPath $splunk_homedir  = $splunk::params::edgeproc_homedir,
  String[1] $scs_group_id         = undef,
  String[1] $scs_tenant_name      = undef,
  String[1] $scs_environment_name = undef,
  String[1] $scs_auth_token       = undef,
) inherits splunk {
  if (defined(Class['splunk::forwarder'])) or (defined(Class['splunk::enterprise'])) {
    fail('Splunk Edge Processor provides a subset of Splunk Enterprise capabilities, and has potentially conflicting resources when included with Splunk Enterprise or Splunk Forwarder on the same node.  Do not include splunk::forwarder or splunk::enterprise on the same node as splunk::edgeprocessor.'
    )
  }

  if (($facts['kernel'] == 'Linux') and ($facts['kernelmajversion'] > '4.9')) or ($facts['kernel'] != 'Linux') {
    fail('This module and the Splunk Edge Processor software is only supported on Linux systems running kernel version 4.9.x or newer.')
  }

  contain 'splunk::edgeprocessor::install'
  contain 'splunk::edgeprocessor::config'
  contain 'splunk::edgeprocessor::service'

  Class['splunk::edgeprocessor::install']
  -> Class['splunk::edgeprocessor::config']
  ~> Class['splunk::edgeprocessor::service']
}
