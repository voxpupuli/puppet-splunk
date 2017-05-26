
SPLUNK_SERVER_TYPES = {
  splunk_authentication: 'authentication.conf',
  splunk_authorize: 'authorize.conf',
  splunk_distsearch: 'distsearch.conf',
  splunk_indexes: 'indexes.conf',
  splunk_input: 'inputs.conf',
  splunk_limits: 'limits.conf',
  splunk_output: 'outputs.conf',
  splunk_props: 'props.conf',
  splunk_server: 'server.conf',
  splunk_transforms: 'transforms.conf',
  splunk_web: 'web.conf'
}.freeze

SPLUNK_FORWARDER_TYPES = {
  splunkforwarder_input: 'inputs.conf',
  splunkforwarder_output: 'outputs.conf',
  splunkforwarder_props: 'props.conf',
  splunkforwarder_transforms: 'transforms.conf',
  splunkforwarder_web: 'web.conf'
}.freeze

SPLUNK_TYPES = SPLUNK_SERVER_TYPES.merge(SPLUNK_FORWARDER_TYPES)
