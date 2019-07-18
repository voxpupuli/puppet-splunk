# Puppet Module For Splunk

[![Build Status](https://travis-ci.org/voxpupuli/puppet-splunk.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-splunk)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-splunk/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-splunk)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/splunk.svg)](https://forge.puppetlabs.com/puppet/splunk)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/splunk.svg)](https://forge.puppetlabs.com/puppet/splunk)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/splunk.svg)](https://forge.puppetlabs.com/puppet/splunk)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/splunk.svg)](https://forge.puppetlabs.com/puppet/splunk)

#### Table of Contents

1. [Overview](#overview)
1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with splunk](#setup)
    * [What splunk affects](#what-splunk-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with splunk](#beginning-with-splunk)
1. [Usage - Configuration options and additional functionality](#usage)
    * [Upgrade splunk/splunkforwarder packages](#upgrade-splunksplunkforwarder-packages)
      * [Upgrade Example](#upgrade-example)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

This module provides a method to deploy Splunk Enterprise or Splunk Universal
Forwarder with common configurations and ensure the services maintain a running
state. It provides types/providers to interact with the various
Splunk/Forwarder configuration files.

## Module Description

This module does not configure firewall rules. Firewall rules will need to be
configured separately in order to allow for correct operation of Splunk and the
Splunk Universal Forwarder. Additionally, this module does not supply Splunk or
Splunk Universal Forwarder installation media. Installation media will need to
be aquired seperately, and the module configured to use it. Users can use yum
or apt to install these components if they're self-hosted.

## Setup

### What splunk affects

* Installs the Splunk/Forwarder package and manages their config files. It does
  not purge them by default.
* The module will set up both Splunk Enterprise and Splunk Forwarder to run as
  the 'root' user on POSIX platforms.
* By default, enables Splunk Enterprise and Splunk Forwarder boot-start, and
  uses the vendor-generated service file to manage the splunk service.

### Setup Requirements

To begin using this module, use the Puppet Module Tool (PMT) from the command
line to install this module:

`puppet module install puppet-splunk`

This will place the module into your primary module path if you do not utilize
the --target-dir directive.

You can also use r10k or code-manager to deploy the module so ensure that you
have the correct entry in your Puppetfile.

Once the module is in place, there is just a little setup needed.

First, you will need to place your downloaded splunk installers into the files
directory, `<module_path>/splunk/files/`. If you're using r10k or code-manager
you'll need to override the `splunk::params::src_root` parameter to point at a
modulepath outside of the Splunk module because each deploy will overwrite the
files.

The files must be placed according to directory structure example given below.

The expected directory structure is:

     $root_url/
     └── products/
         ├── universalforwarder/
         │   └── releases/
         |       └── $version/
         |           └── $platform/
         |               └── splunkforwarder-${version}-${build}-${additl}
         └── splunk/
             └── releases/
                 └── $version/
                     └── $platform/
                         └── splunk-${version}-${build}-${additl}

A semi-populated example files directory might then contain:

    $root_url/
    └── products/
        ├── universalforwarder/
        │   └── releases/
        |       └── 7.0.0/
        |           ├── linux/
        |           |   ├── splunkforwarder-7.0.0-c8a78efdd40f-linux-2.6-amd64.deb
        |           |   ├── splunkforwarder-7.0.0-c8a78efdd40f-linux-2.6-intel.deb
        |           |   └── splunkforwarder-7.0.0-c8a78efdd40f-linux-2.6-x86_64.rpm
        |           ├── solaris/
        |           └── windows/
        |               └── splunkforwarder-7.0.0-c8a78efdd40f-x64-release.msi
        └── splunk/
            └── releases/
                └── 7.0.0/
                    └── linux/
                        ├── splunk-7.0.0-c8a78efdd40f-linux-2.6-amd64.deb
                        ├── splunk-7.0.0-c8a78efdd40f-linux-2.6-intel.deb
                        └── splunk-7.0.0-c8a78efdd40f-linux-2.6-x86_64.rpm

Second, you will need to supply the `splunk::params` class with three critical
pieces of information.

* The version of Splunk you are using
* The build of Splunk you are using
* The root URL to use to retrieve the packages

In the example given above, the version is 7.0.0, the build is c8a78efdd40f,
and the root URL is puppet:///modules/splunk. See the splunk::params class
documentation for more information.

### Beginning with splunk

Once the Splunk packages are hosted in the users repository or hosted by the
Puppet Server in the modulepath the module is ready to deploy.

## Usage

If a user is installing Splunk Enterprise with packages provided from their
modulepath, this is the most basic way of installing Splunk Server with default
settings:

```puppet
include ::splunk::enterprise
```

This is the most basic way of installing the Splunk Universal Forwarder with
default settings:

```puppet
class { '::splunk::params':
    server => $my_splunk_server,
}

include ::splunk::forwarder
```

Once both Splunk Enterprise and Splunk Universal Forwarder have been deployed
on their respective nodes, the Forwarder is ready to start sending logs.

In order to start sending some log data, users can take advantage of the
`Splunkforwarder_input` type. Here is a basic example of adding an input to
start sending Puppet Server logs:

```puppet
@splunkforwarder_input { 'puppetserver-sourcetype':
  section => 'monitor:///var/log/puppetlabs/puppetserver/puppetserver.log',
  setting => 'sourcetype',
  value   => 'puppetserver',
  tag     => 'splunk_forwarder'
}
```

This virtual resource will get collected by the `::splunk::forwarder` class if
it is tagged with `splunk_forwarder` and will add the appropriate setting to
the inputs.conf file and refresh the service.

### Setting the `admin` user's password

The module has the facility to set Splunk Enterprise's `admin` password at installation time by leveraging the [user-seed.conf](https://docs.splunk.com/Documentation/Splunk/latest/Admin/User-seedconf) method described as a best practice in the Splunk docs. The way Splunk implements this prevents Puppet from managing the password in an idempotent way but makes resetting the password through the web console possible. You can also use Puppet to do a one time reset too by setting the appropriate parameters on `splunk::enterprise` but leaving these parameters set to `true` will cause corrective change on each run of the Puppet Agent.

```puppet
class { 'splunk::enterprise':
  seed_password    => true,
  password_hash    => '$6$jxSX7ra2SNzeJbYE$J95eTTMJjFr/lBoGYvuJUSNKvR7befnBwZUOvr/ky86QGqDXwEwdbgPMfCxW1/PuB/IkC94QLNravkABBkVkV1',
}
```

Alternatively the the `splunk::enterprise::password::seed` class can be used independently of the Puppet Agent through a [Bolt Plan apply block](https://puppet.com/docs/bolt/latest/applying_manifest_blocks.html).

### Upgrade splunk and splunkforwarder packages

This module has the ability to install *and* upgrade the splunk and splunkforwarder packages. All you have to do is declare `package_ensure => 'latest'` when calling the `::splunk` or `::splunk::forwarder` classes.

Upgrades from 7.0.X to >= 7.0.X are not tested.

#### Upgrade Example

The following code will install the 6.6.8 version of the splunk forwarder. Then
comment out the 6.6.8 version and build values and uncomment the 7.1.2 version
and build values. Running puppet again will perform the following:

1. splunk forwarder package is upgraded
    1. splunk service is stopped as part of the package upgrade process
1. new license agreement is automatically accepted
    1. license agreement must be accepted or the splunk service will fail to start
1. splunk service is started

```puppet
# Tell the module to get packages directly from Splunk.
class { '::splunk::params':
  version  => '6.6.8',
  build    => '6c27a8439c1e',
  #version  => '7.1.2',
  #build    => 'a0c72a66db66',
  src_root => 'https://download.splunk.com',
}

# Specifying package_ensure => 'latest' will ensure that the splunk and
# splunkforwarder packages will be upgraded when you specify newer values for
# version and build.
class { '::splunk::forwarder':
  package_ensure => 'latest',
}
```
## Reference

See in file [REFERENCE.md](REFERENCE.md).

## Limitations

- Currently tested manually on Centos 7, but we will eventually add automated
  testing and are targeting compatibility with other platforms.
- Tested with Puppet 5.x
- New installations of splunk up to version 7.2.X are supported, but upgrades
  from  7.0.X to >= 7.0.X are not fully tested
- Enabling boot-start will fail if the unit file already exists.  Splunk does
  not remove unit files during uninstallation, so you may be required to
  manually remove existing unit files before re installing and enabling
  boot-start.


## Development

TBD

## Release Notes/Contributors/Etc

TBD

[authentication.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Authenticationconf
[authorize.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Authenticationconf
[default.meta-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Defaultmetaconf
[deploymentclient.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Deploymentclientconf
[distsearch.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Distsearchconf
[indexes.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Indexesconf
[inputs.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Inputsconf
[limits.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Limitsconf
[outputs.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Outputsconf
[props.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Propsconf
[server.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Serverconf
[serverclass.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Serverclassconf
[transforms.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Transformsconf
[web.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Webconf
