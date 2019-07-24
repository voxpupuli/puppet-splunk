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

* Installs the splunk or splunkforwarder package and manages their config
  files. It does not purge them by default.
* The module will set up both Splunk Enterprise and Splunk Forwarder to run as
  the 'root' user on POSIX platforms.
* By default, enables Splunk Enterprise and Splunk Forwarder boot-start, and
  uses the vendor-generated service file to manage the splunk service.

### Setup Requirements

#### Module Installation

To begin using this module, use the Puppet Module Tool (PMT) from the command
line to install this module:

`puppet module install puppet-splunk`

This will place the module into your primary module path if you do not utilize
the --target-dir directive.

You can also use r10k or code-manager to deploy the module so ensure that you
have the correct entry in your Puppetfile.

#### Package Dependencies

Once the module is in place, you will need to ensure the splunk package(s) are
available.

If your environment has the splunk package(s) available, and the supplied
`package_provider` supports it, it is not required for you to manage the splunk
packages.

Otherwise, you will need to place your downloaded splunk installers into the files
directory, `<module_path>/splunk/files/`. If you're using r10k or code-manager
you'll need to override the `splunk::enterprise::src_root` or
`splunk::forwarder::src_root` parameter to point at a modulepath outside of the
Splunk module because each deploy will overwrite the files.

The files must be placed according to directory structure example given below.

The expected directory structure is:

     $src_root/
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

    $src_root/
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

### Beginning with splunk

Once the Splunk packages are hosted in the users repository or hosted by the
Puppet Server in the modulepath the module is ready to deploy.

## Usage

### Splunk Enterprise

If splunk is already installed on the target node, the splunk `version` and
`build` will be determined by the `splunkenterprise` fact.  You can simply
include the module on your node:

```puppet
include splunk::enterprise
```

Otherwise, if splunk is not installed, you will need to follow the instructions
in Setup Requirements.  You may need to specify `src_root` if the defaults are
not suitable for your environment.  You will also need to specify `release`,
in the format `version-build` as follows:

```yaml
---
splunk::enterprise::release: '7.0.0-c8a78efdd40f'
```

```puppet
include splunk::enterprise
```

### Splunk Forwarder

If splunkforwarder is already installed on the target node, the splunk
`version` and `build` will be determined by the `splunkforwarder` fact.  You
will only need to specify a `server`:

```yaml
---
splunk::forwarder::server: <your.servers.ip.addr>
```

```puppet
include ::splunk::forwarder
```

Otherwise, if splunkforwarder is not installed, you will need to follow the
instructions in Setup Requirements.  You may need to specify `src_root` if the
defaults are not suitable for your environment.  You will also need to specify
`release`, in the format `version-build` as follows:

```yaml
---
splunk::forwarder::release: '7.0.0-c8a78efdd40f'
splunk::forwarder::server: <your.servers.ip.addr>
```

```puppet
include ::splunk::forwarder
```

### Splunk Types

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

Upgrades have not been tested with this module.

## Reference

See in file [REFERENCE.md](REFERENCE.md).

## Limitations

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
