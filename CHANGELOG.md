# Changelog

## 2017-01-12 - Release 5.1.0

This is the last release with Pupept 3 support!
* Modulesync with latest Vox Pupuli defaults
* Fix several markdown issues
* Add missing badges
* Fix several rubocop issues
* Bump min version_requirement for Puppet + deps

## 2016-10-05 Release 5.0.2

Minor bugfix release

### Changes

- #59 - Fixed missing relationship between `Splunk::Addon` defined types and the package resource that creates the parent directory that is required.


## 2016-10-04 Release 5.0.1

Minor bugfix release

### Changes

- #57 - Added refresh relationship between `Splunk::Addon` defined resources and the splunk service


## 2016-10-03 Release 5.0.0

### Migration from puppetlabs/splunk

This module has been migrated from `puppetlabs/splunk` and is now maintained under the [Vox Pupuli](https://voxpupuli.org) namespace as of this release.

### Summary

This major release includes a major internal refactoring and code optimizations around the splunk types and providers as well as changes to how resource purging is handled.  This release should be mostly backwardly compatible with the only notable API change being the title_patterns parsing of resource titles and namevar differences.

See: https://github.com/voxpupuli/puppet-splunk/pull/49

#### Changes

- `section` and `setting` are composite namevars.  This also fixes idempotency issues with duplicate section/setting pairs.
- The resource title is parsed for the title pattern "section/setting" allowing for shorter resource declarations. The new title patterns match `/^([^\/]*)$/` as "section" or `/^(.*)\/(.*)$/` as "section/setting"
- Purging is now done from the `splunk_config` type.  Previously `resources` resource was used, but this was flawed since the providers cannot support an `instances` method and have the ability to change the location of the config files.
- Purging now enabled for all forwarder types
- `forwarder_confdir` and `server_confdir` are now relative to `./etc` not `./etc/system/local` meaning config files can be managed outside of `./etc/system/local`

- (internal) Types use a kind of mixin pattern provided by `PuppetX::Puppetlabs::Splunk::Type.clone_type` so the parameters, properties and methods of the types are centrally managed - but you can still add additional ones, or documentation, to individual types.
- (internal) Providers have been simplified a bit, they are only responsible for defining what their filename is, and they inherit from `Puppet::Type.type(:ini_file).provider(:splunk)` where generic stuff around file_path is set (by `splunk_config`).  This then inturn inherits from the `:ini_file` provider in `puppetlabs-inifile`



## Release 4.0.0
### Summary
This major release includes new features, types and providers, as well as various bugfixes. This release introduces some backwards incompatibility.

#### Backwards Compatibility
- This release features an update to the build and version defaults to point to the latest splunk releases. This will cause installations that have unspecified or using defaults for build and version parameters to be forced into a package update.

#### Features
- Adds tags to resources created by `splunk::forwarder` so they can be easily collected.
- Adds ability to set `ensure => latest` on forwarder package.
- Allows setting `ensure` on server package.
- Exposes splunk forwarder windows install options.
- Adds ability to manage Technology Addons for splunk.
- Adds `splunk_server` type and provider.
- Add `splunk_authentication` type and provider.
- Add `splunk_limits` type and provider.
- Add `splunk_web` type and provider.
- Add `splunk_authorize` type and provider.
- Add `indexes` type and provider.
- Add `distsearch` type and provider.
- Adds the splunkforwarder_web type and provider.
- Adds the ability to run Splunk as a non-root user on posix systems.
- Adds purging for all the new Splunk types.

#### Bugfixes
- Fixes a bug where `$staged_package` could be undef in `$pkg_path_parts`.
- Fixes the dependencies on Exec and File creations.
- Adds conditional logic so you don't have to use `puppet-staging`.
- Change the file mode parameter in the forwarder.pp/init.pp files to
  use a string instead of an integer.
- Fixes bug where the $splunk_user variable was referenced but undeclared for this repo.
- Update the build and version to correctly reference the most recent values.
- The $staged_package variable was referenced before declaration.
- Removes the path parameter from the enable_splunk and enable_splunkforwarder execs because it causes issues on platforms that use the systemd service provider. The resulting init script that the exec generates will not get loaded by the systemd-sysv-generate module.
- Fixes an issue where the splunkweb Service would change from 'stopped' to 'running' on every Puppet run. The pattern for discovering the running service had an incorrect regex.

##2015-09-08 - Release 3.2.1
### Summary
This release fixes compatibility issues with Puppet 4 and the future parser.

#### Fixed
- (MODULES-2448) Collectors with arrays do not work well with Puppet 4 and the future parser

## 2015-07-17 - Release 3.2.0
### Summary
This release adds the ability to install from package repos, add authentication for forwarders, and customize forwarder inputs & outputs.

#### Added
- Class `splunk::password` for managing passwords
- Class `splunk` pkg\_provider attribute for using apt/yum repos.
- Define `splunk::forwarder` parameters for customizing the inputs/outputs

## 2014-12-22 - Release 3.1.1
### Summary

This release fixes a bad checksum for the metadata.json file and also cleans up some lint errors. It also adds missing parameters in `params.pp` for Solaris sparc.

## 2014-08-06 - Release 3.1.0
### Summary

For a current list of features please see the README.
