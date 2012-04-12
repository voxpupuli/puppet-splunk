class splunk inherits splunk::params {
  case $::kernel {
    /(?i)linux/: { include "splunk::linux_${splunk::params::deploy}" }
    /(?i)windows/: { 
      if $splunk::params::deploy == 'syslog' { 
        notify {"Err":
          message => "Syslog configuration is not available for ${::kernel} in this module.",
        }
      }
      else { 
        include "splunk::windows_${splunk::params::deploy}" 
        Exec {
          path => "${::path}\;\"C:\\Program Files\\Splunk\\bin\""
        }
      }
    }
  }
}
