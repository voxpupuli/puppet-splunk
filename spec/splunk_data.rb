
SPLUNK_SERVER_TYPES = {
  :splunk_authentication        => 'system/local/authentication.conf',
  :splunk_authorize             => 'system/local/authorize.conf',
  :splunk_distsearch            => 'system/local/distsearch.conf',
  :splunk_indexes               => 'system/local/indexes.conf',
  :splunk_input                 => 'system/local/inputs.conf',
  :splunk_limits                => 'system/local/limits.conf',
  :splunk_output                => 'system/local/outputs.conf',
  :splunk_props                 => 'system/local/props.conf',
  :splunk_server                => 'system/local/server.conf',
  :splunk_transforms            => 'system/local/transforms.conf',
  :splunk_web                   => 'system/local/web.conf',
}

SPLUNK_FORWARDER_TYPES = {
  :splunkforwarder_input        => 'system/local/inputs.conf',
  :splunkforwarder_output       => 'system/local/outputs.conf',
  :splunkforwarder_props        => 'system/local/props.conf',
  :splunkforwarder_transforms   => 'system/local/transforms.conf',
  :splunkforwarder_web          => 'system/local/web.conf',
}


SPLUNK_TYPES = SPLUNK_SERVER_TYPES.merge(SPLUNK_FORWARDER_TYPES)


