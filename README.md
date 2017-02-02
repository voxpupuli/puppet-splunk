# Splunk module for Puppet

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
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

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

* Installs the Splunk/Forwarder package and manages their config files. It does
  not purge them by default.
* The module will set up both Splunk and Splunkforwarder to run as the 'root'
  user on POSIX platforms.

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

In the example given above, the version is 6.3.3, the build is f44afce176d0,
and the root URL is puppet:///modules/splunk. See the splunk::params class
documentation for more information.

### Beginning with splunk

Once the Splunk packages are hosted in the users repository or hosted by the
Puppet Server in the modulepath the module is ready to deploy.

## Usage

If a user is installing Splunk with packages provided from their modulepath,
this is the most basic way of installing Splunk Server with default settings:

```puppet
include ::splunk
```

This is the most basic way of installing the Splunk Universal Forwarder with
default settings:

```puppet
class { '::splunk::params':
    server => $my_splunk_server,
}

include ::splunk::forwarder
```

Once both Splunk and Splunk Universal Forwarder have been deployed on their
respective nodes, the Forwarder is ready to start sending logs.

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

## Reference

### Types

* `splunk_config`: This is a meta resource used to configur defaults for all the
  splunkforwarder and splunk types. This type should not be declared directly as
  it is declared in `splunk::params` and used internally by the types and providers.

* `splunk_authentication`: Used to manage ini settings in [authentication.conf][authentication.conf-docs]
* `splunk_authorize`: Used to manage ini settings in [authorize.conf][authorize.conf-docs]
* `splunk_distsearch`: Used to manage ini settings in [distsearch.conf][distsearch.conf-docs]
* `splunk_indexes`: Used to manage ini settings in [indexes.conf][indexes.conf-docs]
* `splunk_input`: Used to manage ini settings in [inputs.ocnf][inputs.conf-docs]
* `splunk_limits`: Used to mange ini settings in [limits.conf][limits.conf-docs]
* `splunk_output`: Used to manage ini settings in [outputs.conf][outputs.conf-docs]
* `splunk_props`: Used to manage ini settings in [props.conf][props.conf-docs]
* `splunk_server`: Used to mangage ini settings in [server.conf][server.conf-docs]
* `splunk_transforms`: Used to manage ini settings in [transforms.conf][transforms.conf-docs]
* `splunk_web`: Used to manage ini settings in [web.conf][web.conf-docs]

* `splunkforwarder_input`: Used to manage ini settings in [inputs.ocnf][inputs.conf-docs]
* `splunkforwarder_output`:Used to manage ini settings in [outputs.conf][outputs.conf-docs]
* `splunkforwarder_props`: Used to manage ini settings in [props.conf][props.conf-docs]
* `splunkforwarder_transforms`: Used to manage ini settings in [transforms.conf][transforms.conf-docs]
* `splunkforwarder_web`: Used to manage ini settings in [web.conf][web.conf-docs]

All of the above types use `puppetlabs/ini_file` as a parent and are declared in
an identical way, and accept the following parameters:

* `section`:  The name of the section in the configuration file
* `setting`:  The setting to be managed
* `value`: The value of the setting

Both section and setting are namevars for the types.  Specifying a single string
as the title without a forward slash implies that the title is the section to be
managed (if the section attribute is not defined).  You can also specify the
resource title as `section/setting` and ommit both `section` and `setting` params
for a more shortform way of declaring the resource.   Eg:

```puppet
splunkforwarder_output { 'useless title':
  section => 'default',
  setting => 'defaultGroup',
  value   => 'splunk_9777',
}

splunkforwarder_output { 'default':
  setting => 'defaultGroup',
  value   => 'splunk_9777',
}

splunkforwarder_output { 'default/defaultGroup':
  value   => 'splunk_9777',
}
```

The above resource declarations will all configure the following entry in `outputs.conf`

```
[default]
defaultGroup=splunk_9997
```

Note: if the section contains forward slashes you should not use it as the resource
title and should explicitly declare it with the `section` attribute.

## Parameters

### Class: ::splunk::params

#### `version`

*Optional* Specifies the version of Splunk Enterprise that the module should install.

#### `build`

*Optional* Specifies the build of Splunk Enterprise that the module should use.

#### `src_root`

*Optional* The root path that the staging module will use to find packages for
splunk and splunk::forwarder.

#### `splunkd_port`

*Optional* The splunkd port. Used as a default for both splunk and splunk::forwarder.

#### `logging_port`

*Optional* The port on which to send and listen for logs. Used as a default for
both splunk and splunk::forwarder.

#### `server`

*Optional* The fqdn or IP address of the Splunk server. Used for setting up the
default TCP output and input.

### Class: ::splunk Parameters

#### `package_source`

The source URL for the splunk installation media (typically an RPM, MSI,
etc). If a $src_root parameter is set in splunk::params, this will be
automatically supplied. Otherwise it is required. The URL can be of any
protocol supported by the nanliu/staging module.

#### `package_name`

The name of the package(s) Puppet will use to install Splunk.

#### `package_ensure`

Ensure parameter which will get passed to the Splunk package resource.
Default to the value in splunk::params

#### `logging_port`

The port to receive TCP logs on. Default to the port specified in
splunk::params.

#### `splunk_user`

The user to run Splunk as. Default to the value set in splunk::params.

#### `splunkd_port`

The management port for Splunk. Default to the value set in splunk::params.

#### `web_port`

The port on which to service the Splunk Web interface. Default to 8000.

#### `purge_inputs`

*Optional* If set to true, inputs.conf will be purged of configuration that is
no longer managed by the splunk_input type. Default to false.

#### `purge_outputs`

*Optional* If set to true, outputs.conf will be purged of configuration that is
no longer managed by the splunk_output type. Default to false.

#### `purge_authentication`

*Optional* If set to true, authentication.conf will be purged of configuration
that is no longer managed by the splunk_authentication type. Default to false.

#### `purge_authorize`

*Optional* If set to true, authorize.conf will be purged of configuration that
is no longer managed by the splunk_authorize type. Default to false.

#### `purge_distsearch`

*Optional* If set to true, distsearch.conf will be purged of configuration that
is no longer managed by the splunk_distsearch type. Default to false.

#### `purge_indexes`

*Optional* If set to true, indexes.conf will be purged of configuration that is
no longer managed by the splunk_indexes type. Default to false.

#### `purge_limits`

*Optional* If set to true, limits.conf will be purged of configuration that is
no longer managed by the splunk_limits type. Default to false.

#### `purge_props`

*Optional* If set to true, props.conf will be purged of configuration that is
no longer managed by the splunk_props type. Default to false.

#### `purge_server`

*Optional* If set to true, server.conf will be purged of configuration that is
no longer managed by the splunk_server type. Default to false.

#### `purge_transforms`

*Optional* If set to true, transforms.conf will be purged of configuration that
is no longer managed by the splunk_transforms type. Default to false.

#### `purge_web`

*Optional* If set to true, web.conf will be purged of configuration that is no
longer managed by the splunk_web type. Default to false.

### Class ::splunk::forwarder Parameters

#### `server`

*Optional* The fqdn or IP address of the Splunk server. Default to the value in ::splunk::params.

#### `package_source`

The source URL for the splunk installation media (typically an RPM, MSI,
etc). If a $src_root parameter is set in splunk::params, this will be
automatically supplied. Otherwise it is required. The URL can be of any
protocol supported by the nanliu/staging module.

#### `package_name`

The name of the package(s) Puppet will use to install Splunk Universal Forwarder.

#### `package_ensure`

Ensure parameter which will get passed to the Splunk package resource.
Default to the value in ::splunk::params

#### `logging_port`

*Optional* The port on which to send and listen for logs. Default to the value
in ::splunk::params.

#### `splunkd_port`

The management port for Splunk. Default to the value set in splunk::params.

#### `install_options`

This variable is passed to the package resources' *install_options* parameter.
Default to the value in ::splunk::params.

#### `splunk_user`

The user to run Splunk as. Default to the value set in splunk::params.

#### `splunkd_listen`

The address on which splunkd should listen. Defaults to 127.0.0.1.

#### `purge_inputs`

*Optional* If set to true, inputs.conf will be purged of configuration that is
no longer managed by the splunkforwarder_input type. Default to false.

#### `purge_outputs`

*Optional* If set to true, outputs.conf will be purged of configuration that is
no longer managed by the splunk_output type. Default to false.

#### `purge_props`

*Optional* If set to true, props.conf will be purged of configuration that is
no longer managed by the splunk_props type. Default to false.

#### `purge_transforms`

*Optional* If set to true, transforms.conf will be purged of configuration that is
no longer managed by the splunk_transforms type. Default to false.

#### `purge_web`

*Optional* If set to true, web.conf will be purged of configuration that is
no longer managed by the splunk_web type. Default to false.

#### `pkg_provider`

*Optional* This will override the default package provider for the package
resource. Default to undef.

#### `forwarder_confdir`

The root directory where Splunk Universal Forwarder is installed. Default to
the value in ::splunk::params.

#### `forwarder_input`

Used to override the default forwarder_input type defined in ::splunk::params.

#### `forwarder_output`

Used to override the default forwarder_output type defined in ::splunk::params.

#### `create_password`

Not yet implemented.

## Limitations

- Currently tested manually on Centos 7, but we will eventually add automated
  testing and are targeting compatibility with other platforms.
- Tested with Puppet 4.x

## Development

TBD

## Release Notes/Contributors/Etc

TBD

[authentication.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Authenticationconf
[authorize.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Authenticationconf
[distsearch.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Distsearchconf
[indexes.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Indexesconf
[inputs.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Inputsconf
[limits.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Limitsconf
[outputs.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Outputsconf
[props.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Propsconf
[server.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Serverconf
[transforms.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Transformsconf
[web.conf-docs]: http://docs.splunk.com/Documentation/Splunk/latest/Admin/Webconf
