#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with splunk](#setup)
    * [What splunk affects](#what-splunk-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with splunk](#beginning-with-splunk)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module provides a method to deploy Splunk Server or Splunk Universal Forwarder
with common configurations and ensure the services maintain a running
state. It provides types/providers to interact with the various Splunk/Forwarder
configuration files.

## Module Description

This module does not configure firewall rules. Firewall rules will need to be
configured separately in order to allow for correct operation of Splunk and the
Splunk Universal Forwarder. Additionally, this module does not supply Splunk or
Splunk Universal Forwarder installation media. Installation media will need to
be aquired seperately, and the module configured to use it. Users can use yum
or apt to install these components if they're self-hosted.

## Setup

### What splunk affects

* Installs the Splunk/Forwarder package and manages their config files. It does not purge them by default.
* The module will set up both Splunk and Splunkforwarder to run as the 'root' user on POSIX platforms.

### Setup Requirements

To begin using this module, use the Puppet Module Tool (PMT) from the command
line to install this module:

`puppet module install puppetlabs-splunk`

This will place the module into your primary module path if you do not utilize
the --target-dir directive.

You can also use r10k or code-manager to deploy the module so ensure that you have the correct entry in your Puppetfile.

Once the module is in place, there is just a little setup needed.

First, you will need to place your downloaded splunk installers into the files
directory, `<module_path>/splunk/files/`. If you're using r10k or code-manager you'll need to override the `splunk::params::src_root` parameter to point at a modulepath outside of the Splunk module because each deploy will overwrite the files.

The files must be placed according to directory structure example given below.

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
          |       |-- splunk-6.3.3-f44afce176d0-linux-2.6-amd64.deb
          |       |-- splunk-6.3.3-f44afce176d0-linux-2.6-intel.deb
          |       `-- splunk-6.3.3-f44afce176d0-linux-2.6-x86_64.rpm
          `-- universalforwarder
              |-- linux
              |   |-- splunkforwarder-6.3.3-f44afce176d0-linux-2.6-amd64.deb
              |   |-- splunkforwarder-6.3.3-f44afce176d0-linux-2.6-intel.deb
              |   `-- splunkforwarder-6.3.3-f44afce176d0-linux-2.6-x86_64.rpm
              |-- solaris
              |   `-- splunkforwarder-6.3.3-f44afce176d0-solaris-9-intel.pkg
              `-- windows
                  |-- splunkforwarder-6.3.3-f44afce176d0-x64-release.msi
                  `-- splunkforwarder-6.3.3-f44afce176d0-x86-release.msi


Second, you will need to supply the `splunk::params` class with three critical
pieces of information.

* The version of Splunk you are using
* The build of Splunk you are using
* The root URL to use to retrieve the packages

In the example given above, the version is 6.3.3, the build is f44afce176d0, and the
root URL is puppet:///modules/splunk. See the splunk::params class
documentation for more information.

### Beginning with splunk

Once the Splunk packages are hosted in the users repository or hosted by the Puppet Server in the modulepath the module is ready to deploy.

## Usage

If a user is installing Splunk with packages provided from their modulepath, this is the most basic way of installing Splunk Server with default settings:
```puppet
include ::splunk
```
This is the most basic way of installing the Splunk Universal Forwarder with default settings:
```puppet
class { '::splunk::params':
    server => $my_splunk_server,
}

include ::splunk::forwarder
```
Once both Splunk and Splunk Universal Forwarder have been deployed on their respective nodes, the Forwarder is ready to start sending logs.

In order to start sending some log data, users can take advantage of the `Splunkforwarder_input` type. Here is a basic example of adding an input to start sending Puppet Server logs:
```puppet
@splunkforwarder_input { 'puppetserver-sourcetype':
  section => 'monitor:///var/log/puppetlabs/puppetserver/puppetserver.log',
  setting => 'sourcetype',
  value   => 'puppetserver',
  tag     => 'splunk_forwarder'
}
```
This virtual resource will get collected by the `::splunk::forwarder` class if it is tagged with `splunk_forwarder` and will add the appropriate setting to the inputs.conf file and refresh the service.

## Reference

###::splunk::params Parameters

####`version`
####`build`
####`src_root`
####`splunkd_port`
####`logging_port`
####`server`

###::splunk Parameters

####`package_source`
####`package_name`
####`package_ensure`
####`logging_port`
####`splunk_user`
####`splunkd_port`
####`web_port`
####`purge_inputs`
####`purge_outputs`
####`purge_outputs`
####`purge_authentication`
####`purge_authorize`
####`purge_distsearch`
####`purge_indexes`
####`purge_limits`
####`purge_props`
####`purge_server`
####`purge_transforms`
####`purge_web`

###::splunk::forwarder Parameters

####`server`
####`package_source`
####`package_name`
####`package_ensure`
####`logging_port`
####`splunkd_port`
####`install_options`
####`splunk_user`
####`splunkd_listen`
####`purge_inputs`
####`purge_outputs`
####`pkg_provider`
####`forwarder_confdir`
####`forwarder_input`
####`forwarder_output`
####`create_password`

## Limitations

- Currently tested manually on Centos 7, but we will eventually add automated testing and are targeting compatibility with other platforms.
- Tested with Puppet 4.x but should work with older versions. This will get updated soon.

## Development

TBD

## Release Notes/Contributors/Etc

TBD
