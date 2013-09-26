class splunk (
  $purge_splunk_inputs  = false,
  $purge_splunk_outputs = false,
) {

  if $purge_splunk_inputs  { resources { 'splunk_input':  purge => true; } }
  if $purge_splunk_outputs { resources { 'splunk_output': purge => true; } }

}
