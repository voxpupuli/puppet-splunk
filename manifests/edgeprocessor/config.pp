# @summary
#   Private class declared by Class[splunk::edgeprocessor] to contain the required steps
#   for successfully configuring the Splunk Edge Processor
#
class splunk::edgeprocessor::config {
  #Config file with connection details for Splunk Cloud Services environment
  $scs_config = "groupId: ${splunk::edgeprocessor::scs_group_id}\ntenant: ${splunk::edgeprocessor::scs_tenant_name}\nenv: ${splunk::edgeprocessor::scs_environment_name}"

  file { "${splunk::edgeprocessor::splunk_homedir}/etc/config.yaml":
    ensure  => file,
    content => $scs_config,
    owner   => $splunk::edgeprocessor::splunk_user,
    group   => $splunk::edgeprocessor::splunk_user,
  }
  file { "${splunk::edgeprocessor::splunk_homedir}/var/token":
    ensure  => file,
    content => Sensitive($splunk::edgeprocessor::scs_auth_token),
    owner   => $splunk::edgeprocessor::splunk_user,
    group   => $splunk::edgeprocessor::splunk_user,
  }
}
