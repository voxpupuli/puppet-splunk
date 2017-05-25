# Change log

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not impact the functionality of the module.

## [v5.2.0](https://github.com/voxpupuli/puppet-splunk/tree/v5.2.0) (2017-05-25)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v5.1.0...v5.2.0)

**Fixed bugs:**

- Fix Windows Forwarder Installdir [\#102](https://github.com/voxpupuli/puppet-splunk/pull/102) ([TraGicCode](https://github.com/TraGicCode))

**Closed issues:**

- Support .conf files in non-standard locations [\#88](https://github.com/voxpupuli/puppet-splunk/issues/88)
- Warnings produced when splunk resources are in catalog [\#86](https://github.com/voxpupuli/puppet-splunk/issues/86)

**Merged pull requests:**

- Add LICENSE file [\#109](https://github.com/voxpupuli/puppet-splunk/pull/109) ([alexjfisher](https://github.com/alexjfisher))
- This commit sets the splunk\_user for Windows to 'administrator' [\#107](https://github.com/voxpupuli/puppet-splunk/pull/107) ([ralfbosz](https://github.com/ralfbosz))
- Lint fixes [\#101](https://github.com/voxpupuli/puppet-splunk/pull/101) ([treydock](https://github.com/treydock))
- types: Fix purging when section contains '//' [\#96](https://github.com/voxpupuli/puppet-splunk/pull/96) ([iamjamestl](https://github.com/iamjamestl))
- splunk\_config: Only load other splunk types [\#95](https://github.com/voxpupuli/puppet-splunk/pull/95) ([iamjamestl](https://github.com/iamjamestl))
- Remove unneded blank lines [\#93](https://github.com/voxpupuli/puppet-splunk/pull/93) ([roidelapluie](https://github.com/roidelapluie))
- Allow splunk server services to be overridden [\#90](https://github.com/voxpupuli/puppet-splunk/pull/90) ([treydock](https://github.com/treydock))
- Ensure /etc/init.d/splunk is created before splunk services [\#89](https://github.com/voxpupuli/puppet-splunk/pull/89) ([treydock](https://github.com/treydock))
- Update README.md from puppetlabs-splunk [\#85](https://github.com/voxpupuli/puppet-splunk/pull/85) ([Cinderhaze](https://github.com/Cinderhaze))
- Modulesync 0.18.0 [\#83](https://github.com/voxpupuli/puppet-splunk/pull/83) ([bastelfreak](https://github.com/bastelfreak))

## [v5.1.0](https://github.com/voxpupuli/puppet-splunk/tree/v5.1.0) (2017-01-12)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v5.0.2...v5.1.0)

**Closed issues:**

- module doesn't notify splunk restart when changing an input [\#63](https://github.com/voxpupuli/puppet-splunk/issues/63)

**Merged pull requests:**

- release 5.1.0 [\#82](https://github.com/voxpupuli/puppet-splunk/pull/82) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 0.16.7 [\#81](https://github.com/voxpupuli/puppet-splunk/pull/81) ([bastelfreak](https://github.com/bastelfreak))
- Bump min version\_requirement for Puppet + deps [\#80](https://github.com/voxpupuli/puppet-splunk/pull/80) ([juniorsysadmin](https://github.com/juniorsysadmin))
- modulesync 0.16.6 [\#79](https://github.com/voxpupuli/puppet-splunk/pull/79) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 0.16.4 [\#78](https://github.com/voxpupuli/puppet-splunk/pull/78) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 0.16.3 [\#74](https://github.com/voxpupuli/puppet-splunk/pull/74) ([bastelfreak](https://github.com/bastelfreak))
- Make the file reference use the variable and not a fixed path [\#73](https://github.com/voxpupuli/puppet-splunk/pull/73) ([ralfbosz](https://github.com/ralfbosz))
- modulesync 0.15.0 [\#72](https://github.com/voxpupuli/puppet-splunk/pull/72) ([bastelfreak](https://github.com/bastelfreak))
- Revert "Release deprecated version" [\#70](https://github.com/voxpupuli/puppet-splunk/pull/70) ([hunner](https://github.com/hunner))
- Add missing badges [\#66](https://github.com/voxpupuli/puppet-splunk/pull/66) ([dhoppe](https://github.com/dhoppe))
- Update based on voxpupuli/modulesync\_config 0.14.1. This might fix \#62 [\#64](https://github.com/voxpupuli/puppet-splunk/pull/64) ([dhoppe](https://github.com/dhoppe))

## [v5.0.2](https://github.com/voxpupuli/puppet-splunk/tree/v5.0.2) (2016-10-05)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v5.0.1...v5.0.2)

**Fixed bugs:**

- added package dependency to splunk::addon types [\#59](https://github.com/voxpupuli/puppet-splunk/pull/59) ([crayfishx](https://github.com/crayfishx))

**Closed issues:**

- Invalid parameter key\_val\_separator [\#4](https://github.com/voxpupuli/puppet-splunk/issues/4)
- inheritence and version overrides [\#3](https://github.com/voxpupuli/puppet-splunk/issues/3)
- Add ability to upgrade universal forwarders and servers [\#1](https://github.com/voxpupuli/puppet-splunk/issues/1)

**Merged pull requests:**

- prepped 5.0.2 [\#60](https://github.com/voxpupuli/puppet-splunk/pull/60) ([crayfishx](https://github.com/crayfishx))

## [v5.0.1](https://github.com/voxpupuli/puppet-splunk/tree/v5.0.1) (2016-10-04)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v5.0.0...v5.0.1)

**Fixed bugs:**

- Notify service from addons [\#57](https://github.com/voxpupuli/puppet-splunk/pull/57) ([crayfishx](https://github.com/crayfishx))

**Merged pull requests:**

- Prepped 5.0.1 [\#58](https://github.com/voxpupuli/puppet-splunk/pull/58) ([crayfishx](https://github.com/crayfishx))

## [v5.0.0](https://github.com/voxpupuli/puppet-splunk/tree/v5.0.0) (2016-10-03)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/4.0.0...v5.0.0)

**Closed issues:**

- Add other supported OSes to metadata.json [\#54](https://github.com/voxpupuli/puppet-splunk/issues/54)

**Merged pull requests:**

- prepped 5.0.0 [\#56](https://github.com/voxpupuli/puppet-splunk/pull/56) ([crayfishx](https://github.com/crayfishx))
- Added rspec tests for types and splunk\_config and other bugfixes [\#55](https://github.com/voxpupuli/puppet-splunk/pull/55) ([crayfishx](https://github.com/crayfishx))
- Bug fixes, lint, rubocop, spec tests etc. [\#53](https://github.com/voxpupuli/puppet-splunk/pull/53) ([alexjfisher](https://github.com/alexjfisher))
- Add 'Build Status' badge [\#52](https://github.com/voxpupuli/puppet-splunk/pull/52) ([alexjfisher](https://github.com/alexjfisher))
- Modulesync 0.12.7 [\#51](https://github.com/voxpupuli/puppet-splunk/pull/51) ([bastelfreak](https://github.com/bastelfreak))
- Fixed service restarts with forwarders [\#50](https://github.com/voxpupuli/puppet-splunk/pull/50) ([crayfishx](https://github.com/crayfishx))
- \[REVIEW\] \[MODULES-3520\] refactored types and providers and added purging [\#49](https://github.com/voxpupuli/puppet-splunk/pull/49) ([crayfishx](https://github.com/crayfishx))
- \(maint\) Fix resource order for installing splunk forwarders [\#47](https://github.com/voxpupuli/puppet-splunk/pull/47) ([briancain](https://github.com/briancain))

## [4.0.0](https://github.com/voxpupuli/puppet-splunk/tree/4.0.0) (2016-04-11)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/3.2.1...4.0.0)

**Merged pull requests:**

- \(maint\) Release prep. [\#45](https://github.com/voxpupuli/puppet-splunk/pull/45) ([bmjen](https://github.com/bmjen))
- Fix typo in README. [\#44](https://github.com/voxpupuli/puppet-splunk/pull/44) ([Ziaunys](https://github.com/Ziaunys))
- Update README with type documentation. [\#43](https://github.com/voxpupuli/puppet-splunk/pull/43) ([Ziaunys](https://github.com/Ziaunys))
- Fix module errors discovered while testing. [\#42](https://github.com/voxpupuli/puppet-splunk/pull/42) ([Ziaunys](https://github.com/Ziaunys))
- Add acceptance test skeleton. [\#41](https://github.com/voxpupuli/puppet-splunk/pull/41) ([Ziaunys](https://github.com/Ziaunys))
- Change file mode to string. [\#40](https://github.com/voxpupuli/puppet-splunk/pull/40) ([Ziaunys](https://github.com/Ziaunys))
- Add a more modern version of our README template with updates. [\#39](https://github.com/voxpupuli/puppet-splunk/pull/39) ([Ziaunys](https://github.com/Ziaunys))
- Various updates and fixes [\#38](https://github.com/voxpupuli/puppet-splunk/pull/38) ([Ziaunys](https://github.com/Ziaunys))
- Update the resource ordering for the new Splunk types. [\#37](https://github.com/voxpupuli/puppet-splunk/pull/37) ([Ziaunys](https://github.com/Ziaunys))
- Add conditional logic for using the staging module [\#36](https://github.com/voxpupuli/puppet-splunk/pull/36) ([Ziaunys](https://github.com/Ziaunys))
- Create additional Splunk types/providers [\#35](https://github.com/voxpupuli/puppet-splunk/pull/35) ([Ziaunys](https://github.com/Ziaunys))
- Add splunk\_server type and provider [\#34](https://github.com/voxpupuli/puppet-splunk/pull/34) ([Ziaunys](https://github.com/Ziaunys))
- Correct the descriptions of existing splunk types [\#33](https://github.com/voxpupuli/puppet-splunk/pull/33) ([Ziaunys](https://github.com/Ziaunys))
- Actually use the variable somewhere [\#32](https://github.com/voxpupuli/puppet-splunk/pull/32) ([kyledecot](https://github.com/kyledecot))
- Server ensure [\#31](https://github.com/voxpupuli/puppet-splunk/pull/31) ([kyledecot](https://github.com/kyledecot))
- Adds param for ensuring forwarder can be the latest argument [\#30](https://github.com/voxpupuli/puppet-splunk/pull/30) ([bmjen](https://github.com/bmjen))
- forwarder::pkg\_provider should default to $splunk::params::pkg\_provider [\#29](https://github.com/voxpupuli/puppet-splunk/pull/29) ([hunner](https://github.com/hunner))
- Fix dependencies [\#28](https://github.com/voxpupuli/puppet-splunk/pull/28) ([mpdude](https://github.com/mpdude))
- \(MODULES-2953\) fix order of assignments [\#27](https://github.com/voxpupuli/puppet-splunk/pull/27) ([DavidS](https://github.com/DavidS))
- added technology addon feature [\#26](https://github.com/voxpupuli/puppet-splunk/pull/26) ([crayfishx](https://github.com/crayfishx))
- config items are collected with tag - make sure it exists [\#25](https://github.com/voxpupuli/puppet-splunk/pull/25) ([asquelt](https://github.com/asquelt))
- Expose splunk forwarder windows install options [\#14](https://github.com/voxpupuli/puppet-splunk/pull/14) ([nanliu](https://github.com/nanliu))

## [3.2.1](https://github.com/voxpupuli/puppet-splunk/tree/3.2.1) (2015-09-08)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/3.2.0...3.2.1)

**Merged pull requests:**

- 3.2.1 prep [\#24](https://github.com/voxpupuli/puppet-splunk/pull/24) ([underscorgan](https://github.com/underscorgan))
- MODULES-2448 - Improved collector compatibility [\#23](https://github.com/voxpupuli/puppet-splunk/pull/23) ([underscorgan](https://github.com/underscorgan))

## [3.2.0](https://github.com/voxpupuli/puppet-splunk/tree/3.2.0) (2015-07-21)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/3.1.1...3.2.0)

**Merged pull requests:**

- Release 3.2.0 [\#19](https://github.com/voxpupuli/puppet-splunk/pull/19) ([hunner](https://github.com/hunner))
- Update splunkforwarder\_output [\#18](https://github.com/voxpupuli/puppet-splunk/pull/18) ([hunner](https://github.com/hunner))
- Repository and password changes [\#17](https://github.com/voxpupuli/puppet-splunk/pull/17) ([ckyriakidou](https://github.com/ckyriakidou))
- \(MODULES-2096\) Move default cases last [\#16](https://github.com/voxpupuli/puppet-splunk/pull/16) ([DavidS](https://github.com/DavidS))

## [3.1.1](https://github.com/voxpupuli/puppet-splunk/tree/3.1.1) (2014-12-18)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/3.1.0...3.1.1)

**Merged pull requests:**

- 3.1.1 prep [\#13](https://github.com/voxpupuli/puppet-splunk/pull/13) ([underscorgan](https://github.com/underscorgan))
- Fix lint issues [\#12](https://github.com/voxpupuli/puppet-splunk/pull/12) ([underscorgan](https://github.com/underscorgan))
- Add solaris sparc parameters. [\#10](https://github.com/voxpupuli/puppet-splunk/pull/10) ([nanliu](https://github.com/nanliu))

## [3.1.0](https://github.com/voxpupuli/puppet-splunk/tree/3.1.0) (2014-08-06)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/3.0.1...3.1.0)

**Merged pull requests:**

- 3.1.0 prep [\#11](https://github.com/voxpupuli/puppet-splunk/pull/11) ([underscorgan](https://github.com/underscorgan))
- Update the name of the module for PMT install. [\#8](https://github.com/voxpupuli/puppet-splunk/pull/8) ([metcalfc](https://github.com/metcalfc))
- Add integration tests and fix forwarder bug [\#7](https://github.com/voxpupuli/puppet-splunk/pull/7) ([hunner](https://github.com/hunner))
- Add T&Ps for Splunk indexer and forwarder props and transforms [\#6](https://github.com/voxpupuli/puppet-splunk/pull/6) ([hunner](https://github.com/hunner))
- Add dependency on stdlib \>= 2.4.0 [\#5](https://github.com/voxpupuli/puppet-splunk/pull/5) ([hunner](https://github.com/hunner))

## [3.0.1](https://github.com/voxpupuli/puppet-splunk/tree/3.0.1) (2013-12-02)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/3.0.0...3.0.1)

## [3.0.0](https://github.com/voxpupuli/puppet-splunk/tree/3.0.0) (2013-11-22)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/2.0.1...3.0.0)

## [2.0.1](https://github.com/voxpupuli/puppet-splunk/tree/2.0.1) (2013-10-25)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/2.0.0...2.0.1)

## [2.0.0](https://github.com/voxpupuli/puppet-splunk/tree/2.0.0) (2013-09-30)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/0.3.0...2.0.0)

## [0.3.0](https://github.com/voxpupuli/puppet-splunk/tree/0.3.0) (2013-08-27)
[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/0.2.0...0.3.0)

**Merged pull requests:**

- typo in puppet module install command [\#2](https://github.com/voxpupuli/puppet-splunk/pull/2) ([fiddyspence](https://github.com/fiddyspence))

## [0.2.0](https://github.com/voxpupuli/puppet-splunk/tree/0.2.0) (2012-12-18)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*