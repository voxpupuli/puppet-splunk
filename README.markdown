### Overview

This module provides a method to deploy Splunk Server or Splunk Universal
Forwarder with common configurations and ensure the services maintain a running
state.

This module does not configure firewall rules. Firewall rules will need to be
configured separately in order to allow for correct operation of Splunk and the
Splunk Universal Forwarder. Additionally, this module does not supply Splunk or
Splunk Universal Forwarder installation media. Installation media will need to
be aquired seperately, and the module configured to use it.

### Installation & Setup

To begin using this module, use the Puppet Module Tool (PMT) from the command
line to install this module:

`puppet module install puppetlabs-splunk`

This will place the module into your primary module path if you do not utilize
the --target-dir directive.

Once the module is in place, there is just a little setup needed.

First, you will need to place your downloaded splunk installers into the files
directory, `<module_path>/splunk/files/`. The files must be placed according to
directory structure example given below.

The expected directory structure is:

      `-- files
          |-- splunk
          |   `-- $platform
          |       `-- splunk-${version}-${build}-${additl}
          `-- universalforwarder
              `-- $platform
                  `-- splunkforwarder-${version}-${build}-${additl}

A semi-populated example files directory might then contain:

      `-- files
          |-- splunk
          |   `-- linux
          |       |-- splunk-4.3.2-123586-linux-2.6-amd64.deb
          |       |-- splunk-4.3.2-123586-linux-2.6-intel.deb
          |       `-- splunk-4.3.2-123586-linux-2.6-x86_64.rpm
          `-- universalforwarder
              |-- linux
              |   |-- splunkforwarder-4.3.2-123586-linux-2.6-amd64.deb
              |   |-- splunkforwarder-4.3.2-123586-linux-2.6-intel.deb
              |   `-- splunkforwarder-4.3.2-123586-linux-2.6-x86_64.rpm
              |-- solaris
              |   `-- splunkforwarder-4.3.2-123586-solaris-9-intel.pkg
              `-- windows
                  |-- splunkforwarder-4.3.2-123586-x64-release.msi
                  `-- splunkforwarder-4.3.2-123586-x86-release.msi

Second, you will need to supply the `splunk::params` class with three critical
pieces of information.

* The version of Splunk you are using
* The build of Splunk you are using
* The root URL to use to retrieve the packages

In the example given above, the version is 4.3.2, the build is 123586, and the
root URL is puppet:///modules/splunk. See the splunk::params class
documentation for more information.

