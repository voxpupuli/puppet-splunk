### Overview

This module was originally forked from https://github.com/dhogland/splunk

This module provides a method to deploy Splunk Server or Splunk Universal
Forwarder with common configurations and ensure the services maintain a running
state. Alternate configuration is available for rsyslog as well if you do not
need the full Splunk agent.

This module was written using the Puppet Enterprise Console as the External
Node Classifier. Modifying to leverage a different ENC (or none at all) should
be simple enough, just give a look at params.pp.

This module does require the puppetlabs/firewall module as specified ports will
automatically be opened in your firewall to allow for incoming traffic.

### Disclaimer

The following platform/deployments have been tested:

* Windows 2008 (32 and 64bit) - Server and Universal Forwarder
* Windows 2003 (32 and 64bit) - Server and Universal Forwarder
* CentOS 6.x (32 and 64bit)   - Server, Universal Forwarder and rsyslog

### Downloading

It is recommended that you use the puppet module tool described in the
Installation section below to download and implement this module.

### Installation & Setup

To begin using this module, use the Puppet Module Tool (PMT) from the command
line to install this module:

`puppet module install dhogland-splunk`

This will place the module into your primary module path if you do not utilize
the -dir directive.

Once the module is in place, there is just a little setup needed:

* first, you will need to place your downloaded splunk installers into the
  files directory, <module_path>/splunk/files/.
  - validate in the params.pp file
     + the version you downloaded matches the $splunk_ver variable. If not,
       change the value to match.
     + the full file names for $installer match what you have placed into the
       files directory.
* second, you will need to configure a few objects in the Console
  - create a class and call it `splunk`.
  - create a group named to your desire with the following parameters:
     + splunk\_logging\_server
         - This is the server that will act as your Splunk Central Logging
           Server
     + splunk\_syslog\_port
         - This is the desired port that tcp syslog messages will be
           configured to listen on for the Server and send to from rsyslog.
           This is raw tcp syslog data.
     + splunk\_forwarder\_port
         - This is the desired port that splunktcp syslog messages will be
           configured to listen on for the Server and send to from the
           Forwarder, this is a separate port because data sent from the
           Splunk Forwarders are 'cooked' data and must be recieved by a
           splunktcp listener.
     + splunk\_deploy
         - Valid values for this are server, forwarder or syslog. If `server`
           is defined the Splunk Server will be deployed and configured. If
           `forwarder` is defined the Splunk Universal Forwarder will be
           deployed and configured. If `syslog` is defined (only available for
           Linux hosts), rsyslog will be ensured that it is installed, running
           and sending all messages to desired central logging server over the
           proper port.
  - finally, create child groups to the first group and override the
    splunk_deploy parameter as needed (see example below).

### Example setup

In my files directory I've placed the following version(s) of Splunk:

        splunk-4.3.1-119532.i386.rpm
        splunk-4.3.1-119532-linux-2.6-amd64.deb
        splunk-4.3.1-119532-linux-2.6-intel.deb
        splunk-4.3.1-119532-linux-2.6-x86_64.rpm
        splunk-4.3.1-119532-x64-release.msi
        splunk-4.3.1-119532-x86-release.msi
        splunkforwarder-4.3.1-119532.i386.rpm
        splunkforwarder-4.3.1-119532-linux-2.6-amd64.deb
        splunkforwarder-4.3.1-119532-linux-2.6-intel.deb
        splunkforwarder-4.3.1-119532-linux-2.6-x86_64.rpm
        splunkforwarder-4.3.1-119532-x64-release.msi
        splunkforwarder-4.3.1-119532-x86-release.msi

In my params.pp file I validate that the following variables match what I have
in my files dir:

* $splunk_ver = '4.3.1-119532'
* $installer will evaluate out to match the appropriate file in my file
  directory. eg. splunk-${splunk_ver}.i386.rpm matches
  splunk-4.3.1-119532.i386.rpm and falls under the appropriate architecture,
  operatingsystem and deploy cases.

In my Console I have created the following classes, groups/parameters:

        * Classes
          - splunk
        * Groups/parameters
          - splunk (has the class splunk associated to it)
            + splunk_logging_server = splunk.mydomain.lan
            + splunk_forwarder_port = 8002
            + splunk_syslog_port = 8001
            + splunk_deploy = server
          - forwarder (child group of splunk)
            + splunk_deploy = forwarder
          - syslog (child group of splunk)
            + splunk_deploy = syslog

Now with this set up, I simply need to add a node to the main splunk **group**
to designate what server will be handling the role of the Splunk Server and
assign nodes to either the forwarder or syslog group depending on if I want to
configure the forwarder for the node or configure rsyslog to report data to the
defined Server.

### Bugs

