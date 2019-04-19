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

### Types

* `splunk_config`: This is a meta resource used to configure defaults for all the
  splunkforwarder and splunk types. This type should not be declared directly as
  it is declared in `splunk::params` and used internally by the types and providers.

* `splunk_authentication`: Used to manage ini settings in [authentication.conf][authentication.conf-docs]
* `splunk_authorize`: Used to manage ini settings in [authorize.conf][authorize.conf-docs]
* `splunk_deploymentclient`: Used to manage ini settings in [deploymentclient.conf][deploymentclient.conf-docs]
* `splunk_distsearch`: Used to manage ini settings in [distsearch.conf][distsearch.conf-docs]
* `splunk_indexes`: Used to manage ini settings in [indexes.conf][indexes.conf-docs]
* `splunk_input`: Used to manage ini settings in [inputs.conf][inputs.conf-docs]
* `splunk_limits`: Used to mange ini settings in [limits.conf][limits.conf-docs]
* `splunk_metadata`: Used to manage ini settings in [default.meta][default.meta-docs]
* `splunk_output`: Used to manage ini settings in [outputs.conf][outputs.conf-docs]
* `splunk_props`: Used to manage ini settings in [props.conf][props.conf-docs]
* `splunk_server`: Used to manage ini settings in [server.conf][server.conf-docs]
* `splunk_serverclass`: Used to manage ini settings in [serverclass.conf][serverclass.conf-docs]
* `splunk_transforms`: Used to manage ini settings in [transforms.conf][transforms.conf-docs]
* `splunk_web`: Used to manage ini settings in [web.conf][web.conf-docs]

* `splunkforwarder_deploymentclient`: Used to manage ini settings in [deploymentclient.conf][deploymentclient.conf-docs]
* `splunkforwarder_input`: Used to manage ini settings in [inputs.conf][inputs.conf-docs]
* `splunkforwarder_output`:Used to manage ini settings in [outputs.conf][outputs.conf-docs]
* `splunkforwarder_props`: Used to manage ini settings in [props.conf][props.conf-docs]
* `splunkforwarder_transforms`: Used to manage ini settings in [transforms.conf][transforms.conf-docs]
* `splunkforwarder_web`: Used to manage ini settings in [web.conf][web.conf-docs]
* `splunkforwarder_limits`: Used to manage ini settings in [limits.conf][limits.conf-docs]
* `splunkforwarder_server`: Used to manage ini settings in [server.conf][server.conf-docs]

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

*Optional* Specifies the version of Splunk Enterprise and Splunk Forwarder that
the module should install.

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

#### `forwarder_installdir`

*Optional* Directory in which to install and manage Splunk Forwarder

#### `enterprise_installdir`

*Optional* Directory in which to install and mange Splunk Enterprise

#### `boot_start`

*Optional* Enable splunk boot-start mode.  Provision a service file.

### Class: ::splunk::enterprise Parameters

#### `version`

Specifies the version of Splunk Enterprise the module should install and
manage.  Defaults to the value set in splunk::params.

#### `package_name`

The name of the package(s) Puppet will use to install Splunk.

#### `package_ensure`

Ensure parameter which will get passed to the Splunk package resource.
Defaults to the value in splunk::params.

#### `staging_dir`

Root of the archive path to host the Splunk package.  Defaults to the value in
splunk::params.

#### `enterprise_package_src`

The source URL for the splunk installation media (typically an RPM, MSI,
etc). If a `$src_root` parameter is set in splunk::params, this will be
automatically supplied. Otherwise it is required. The URL can be of any
protocol supported by the nanliu/staging module. On Windows, this can be
a UNC path to the MSI. Defaults to the value in splunk::params.

#### `package_provider`

The package management system used to host the Splunk packages.  Defaults to the
value in splunk::params.

#### `manage_package_source`

Whether or not to use the supplied `enterprise_package_src` param.  Defaults to
true.

#### `package_source`

*Optional* The source URL for the splunk installation media (typically an RPM,
MSI, etc). If `enterprise_package_src` parameter is set in splunk::params and
`manage_package_source` is true, this will be automatically supplied. Otherwise
it is required. The URL can be of any protocol supported by the nanliu/staging
module. On Windows, this can be a UNC path to the MSI.  Defaults to undef.

#### `install_options`

This variable is passed to the package resources' *install_options* parameter.
Defaults to the value in ::splunk::params.

#### `manage_splunk_user`

Whether or not to manage the user splunk runuser.  Defaults to false.

#### `splunk_user`

The user to run Splunk as. Defaults to the value set in splunk::params.

#### `enterprise_homedir`

Specifies the Splunk Enterprise home directory.  Defaults to the value set in
splunk::params.

#### `enterprise_confdir`

Specifies the Splunk Enterprise configuration directory.  Defaults to the value
set in splunk::params.

#### `service_name`

The name of the Splunk Enterprise service.  Defaults to the value set in
splunk::params.

#### `service_file`

The path to the Splunk Enterprise service file.  Defaults to the value set in
splunk::params.

#### `boot_start`

Whether or not to enable splunk boot-start, which generates a service file to
manage the Splunk Enterprise service.  Defaults to the value set in
splunk::params.

#### `use_default_config`

Whether or not the module should manage a default set of Splunk Enterprise
configuration parameters.  Defaults to true.

#### `input_default_host`

Part of the default config.  Sets the `splunk_input` default host.  Defaults to
`facts['fqdn']`.

#### `input_connection_host`

Part of the default config.  Sets the `splunk_input` connection host.  Defaults
to dns.

#### `splunkd_listen`

The address on which splunkd should listen. Defaults to 127.0.0.1.

#### `logging_port`

The port to receive TCP logs on. Defaults to the port specified in
splunk::params.

#### `splunkd_port`

The management port for Splunk. Defaults to the value set in splunk::params.

#### `web_port`

The port on which to service the Splunk Web interface. Defaults to 8000.

#### `purge_inputs`

If set to true, inputs.conf will be purged of configuration that is
no longer managed by the `splunk_input` type. Defaults to false.

#### `purge_outputs`

If set to true, outputs.conf will be purged of configuration that is
no longer managed by the `splunk_output` type. Defaults to false.

#### `purge_authentication`

If set to true, authentication.conf will be purged of configuration
that is no longer managed by the `splunk_authentication` type. Defaults to false.

#### `purge_authorize`

If set to true, authorize.conf will be purged of configuration that
is no longer managed by the `splunk_authorize` type. Defaults to false.

#### `purge_distsearch`

If set to true, distsearch.conf will be purged of configuration that
is no longer managed by the `splunk_distsearch` type. Defaults to false.

#### `purge_indexes`

If set to true, indexes.conf will be purged of configuration that is
no longer managed by the `splunk_indexes` type. Defaults to false.

#### `purge_limits`

If set to true, limits.conf will be purged of configuration that is
no longer managed by the `splunk_limits` type. Defaults to false.

#### `purge_props`

If set to true, props.conf will be purged of configuration that is
no longer managed by the `splunk_props` type. Defaults to false.

#### `purge_server`

If set to true, server.conf will be purged of configuration that is
no longer managed by the `splunk_server` type. Defaults to false.

#### `purge_transforms`

If set to true, transforms.conf will be purged of configuration that
is no longer managed by the `splunk_transforms` type. Defaults to false.

#### `purge_web`

If set to true, web.conf will be purged of configuration that is no
longer managed by the `splunk_web type`. Defaults to false.

#### `manage_password`

If set to true, Manage the contents of splunk.secret and passwd.  Defaults to
the value set in splunk::params.

#### `password_config_file`

Which file to put the password in i.e. in linux it would be
/opt/splunk/etc/passwd.  Defaults to the value set in splunk::params.

#### `password_content`

The hashed password username/details for the user.  Defaults to the value set
in splunk::params.

#### `secret_file`

Which file we should put the secret in.  Defaults to the value set in
splunk::params.

#### `secret`

The secret used to salt the splunk password.  Defaults to the value set in
splunk::params.

### Class ::splunk::forwarder Parameters

#### `server`

The fqdn or IP address of the Splunk server. Defaults to the value in ::splunk::params.

#### `version`

Specifies the version of Splunk Forwarder the module should install and
manage.  Defaults to the value set in splunk::params.

#### `package_name`

The name of the package(s) Puppet will use to install Splunk Forwarder.
Defaults to the value set in splunk::params.

#### `package_ensure`

Ensure parameter which will get passed to the Splunk package resource.
Defaults to the value in ::splunk::params.

#### `staging_subdir`

Root of the archive path to host the Splunk package.  Defaults to the value in
splunk::params.

#### `path_delimiter`

The path separator used in the archived path of the Splunk package.  Defaults to
the value in splunk::params.

#### `forwarder_package_src`

The source URL for the splunk installation media (typically an RPM, MSI,
etc). If a `$src_root` parameter is set in splunk::params, this will be
automatically supplied. Otherwise it is required. The URL can be of any
protocol supported by the nanliu/staging module. On Windows, this can be
a UNC path to the MSI. Defaults to the value in splunk::params.

#### `package_provider`

The package management system used to host the Splunk packages.  Defaults to the
value in splunk::params.

#### `manage_package_source`

Whether or not to use the supplied `forwarder_package_src` param.  Defaults to
true.

#### `package_source`

*Optional* The source URL for the splunk installation media (typically an RPM,
MSI, etc). If `enterprise_package_src` parameter is set in splunk::params and
`manage_package_source` is true, this will be automatically supplied. Otherwise
it is required. The URL can be of any protocol supported by the nanliu/staging
module. On Windows, this can be a UNC path to the MSI.  Defaults to undef.

#### `install_options`

This variable is passed to the package resources' *install_options* parameter.
Defaults to the value in ::splunk::params.

#### `manage_splunk_user`

Whether or not to manage the user splunk runuser.  Defaults to false.

#### `splunk_user`

The user to run Splunk as. Defaults to the value set in splunk::params.

#### `forwarder_homedir`

Specifies the Splunk Forwarder home directory.  Defaults to the value set in
splunk::params.

#### `forwarder_confdir`

Specifies the Splunk Forwarder configuration directory.  Defaults to the value
set in splunk::params.

#### `service_name`

The name of the Splunk Forwarder service.  Defaults to the value set in
splunk::params.

#### `service_file`

The path to the Splunk Forwarder service file.  Defaults to the value set in
splunk::params.

#### `boot_start`

Whether or not to enable splunk boot-start, which generates a service file to
manage the Splunk Forwarder service.  Defaults to the value set in
splunk::params.

#### `use_default_config`

Whether or not the module should manage a default set of Splunk Forwarder
configuration parameters.  Defaults to true.

#### `splunkd_listen`

The address on which splunkd should listen. Defaults to 127.0.0.1.

#### `splunkd_port`

The management port for Splunk. Defaults to the value set in splunk::params.

#### `logging_port`

The port on which to send and listen for logs. Defaults to the value
in splunk::params.

#### `purge_inputs`

*Optional* If set to true, inputs.conf will be purged of configuration that is
no longer managed by the `splunkforwarder_input` type. Defaults to false.

#### `purge_outputs`

*Optional* If set to true, outputs.conf will be purged of configuration that is
no longer managed by the `splunk_output` type. Defaults to false.

#### `purge_props`

*Optional* If set to true, props.conf will be purged of configuration that is
no longer managed by the `splunk_props` type. Defaults to false.

#### `purge_transforms`

*Optional* If set to true, transforms.conf will be purged of configuration that is
no longer managed by the `splunk_transforms` type. Defaults to false.

#### `purge_web`

*Optional* If set to true, web.conf will be purged of configuration that is
no longer managed by the `splunk_web` type. Defaults to false.

#### `forwarder_input`

Used to override the default `forwarder_input` type defined in splunk::params.

#### `forwarder_output`

Used to override the default `forwarder_output` type defined in splunk::params.

#### `manage_password`

If set to true, Manage the contents of splunk.secret and passwd.  Defaults to
the value set in splunk::params.

#### `password_config_file`

Which file to put the password in i.e. in linux it would be
/opt/splunkforwarder/etc/passwd.  Defaults to the value set in splunk::params.

#### `password_content`

The hashed password username/details for the user.  Defaults to the value set
in splunk::params.

#### `secret_file`

Which file we should put the secret in.  Defaults to the value set in
splunk::params.

#### `secret`

The secret used to salt the splunk password.  Defaults to the value set in
splunk::params.

#### `addons`

Manage splunk addons, see `splunk::addons`.  Defaults to an empty Hash.

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
