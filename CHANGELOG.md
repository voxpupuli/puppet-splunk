# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [10.0.0](https://github.com/voxpupuli/puppet-splunk/tree/10.0.0)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v9.1.1...10.0.0)

**Breaking changes:**

- Use namespaced ensure\_packages, require puppetlabs/stdlib 9.x [\#360](https://github.com/voxpupuli/puppet-splunk/pull/360) ([gcoxmoz](https://github.com/gcoxmoz))
- Drop Ubuntu 18.04 support [\#355](https://github.com/voxpupuli/puppet-splunk/pull/355) ([zilchms](https://github.com/zilchms))
- Drop Ubuntu 16.04 support [\#354](https://github.com/voxpupuli/puppet-splunk/pull/354) ([zilchms](https://github.com/zilchms))
- Drop Debian 9 support [\#353](https://github.com/voxpupuli/puppet-splunk/pull/353) ([zilchms](https://github.com/zilchms))
- Drop Puppet 6 support [\#343](https://github.com/voxpupuli/puppet-splunk/pull/343) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Rocky and AlmaLinux 8 and 9 support [\#359](https://github.com/voxpupuli/puppet-splunk/pull/359) ([zilchms](https://github.com/zilchms))
- Add EL 8 and 9 support [\#358](https://github.com/voxpupuli/puppet-splunk/pull/358) ([zilchms](https://github.com/zilchms))
- Add Ubuntu 22.04 support [\#357](https://github.com/voxpupuli/puppet-splunk/pull/357) ([zilchms](https://github.com/zilchms))
- Ensure compatibility with Splunk 9.2.0.1 and 9.0.0 [\#350](https://github.com/voxpupuli/puppet-splunk/pull/350) ([siegy22](https://github.com/siegy22))
- Add Puppet 8 support [\#347](https://github.com/voxpupuli/puppet-splunk/pull/347) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Allow 9.x [\#346](https://github.com/voxpupuli/puppet-splunk/pull/346) ([bastelfreak](https://github.com/bastelfreak))
- Allow inifile 6.x, concat 9.x, archive 7.x [\#345](https://github.com/voxpupuli/puppet-splunk/pull/345) ([gcoxmoz](https://github.com/gcoxmoz))
- enable the puppet-archive `allow_insecure` parameter [\#340](https://github.com/voxpupuli/puppet-splunk/pull/340) ([mwpower](https://github.com/mwpower))

**Fixed bugs:**

- Splunk 9.0.5+ Package Not Found on RedHat x86\_64 [\#348](https://github.com/voxpupuli/puppet-splunk/issues/348)
- pass4SymmKey not read properly [\#284](https://github.com/voxpupuli/puppet-splunk/issues/284)
- pass4SymmKey setting causes restarts of splunk [\#197](https://github.com/voxpupuli/puppet-splunk/issues/197)
- Add workaround for Windows based Splunk UF 9.1.3 known issue [\#365](https://github.com/voxpupuli/puppet-splunk/pull/365) ([siegy22](https://github.com/siegy22))
- Safer Splunk Enterprise version check [\#339](https://github.com/voxpupuli/puppet-splunk/pull/339) ([gsandine](https://github.com/gsandine))

**Merged pull requests:**

- Updated README.md to make it clear that this module can download directly from the Splunk website [\#367](https://github.com/voxpupuli/puppet-splunk/pull/367) ([Tamerz](https://github.com/Tamerz))
- Miscellaneous README improvements [\#364](https://github.com/voxpupuli/puppet-splunk/pull/364) ([siegy22](https://github.com/siegy22))
- Fix upgrading Splunk Enterprise [\#363](https://github.com/voxpupuli/puppet-splunk/pull/363) ([siegy22](https://github.com/siegy22))
- Allow the user to set encrypted values directly [\#362](https://github.com/voxpupuli/puppet-splunk/pull/362) ([siegy22](https://github.com/siegy22))
- Remove legacy top-scope syntax [\#351](https://github.com/voxpupuli/puppet-splunk/pull/351) ([smortex](https://github.com/smortex))

## [v9.1.1](https://github.com/voxpupuli/puppet-splunk/tree/v9.1.1) (2022-07-14)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v9.1.0...v9.1.1)

**Fixed bugs:**

- Don't install net-tools on Solaris [\#335](https://github.com/voxpupuli/puppet-splunk/pull/335) ([davemcdonnell](https://github.com/davemcdonnell))

## [v9.1.0](https://github.com/voxpupuli/puppet-splunk/tree/v9.1.0) (2022-07-12)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v9.0.0...v9.1.0)

**Implemented enhancements:**

- Allow user-seed.conf to set a username besides 'admin' [\#323](https://github.com/voxpupuli/puppet-splunk/pull/323) ([gcoxmoz](https://github.com/gcoxmoz))
- Add extract\_command as a parameter to splunk::addon [\#321](https://github.com/voxpupuli/puppet-splunk/pull/321) ([gcoxmoz](https://github.com/gcoxmoz))

**Fixed bugs:**

- Forwarder service won't start due to incorrect permissions [\#310](https://github.com/voxpupuli/puppet-splunk/issues/310)
- Use init provider on solaris when managing service [\#336](https://github.com/voxpupuli/puppet-splunk/pull/336) ([davemcdonnell](https://github.com/davemcdonnell))
- Explicitly set user on call to 'splunk enable boot-start' [\#334](https://github.com/voxpupuli/puppet-splunk/pull/334) ([davemcdonnell](https://github.com/davemcdonnell))
- Ensure facter doesn't stuck in interactive session while retrieving splunk forwarder version [\#320](https://github.com/voxpupuli/puppet-splunk/pull/320) ([mvandegarde](https://github.com/mvandegarde))

**Closed issues:**

- Warning: Secrets file NOT found [\#330](https://github.com/voxpupuli/puppet-splunk/issues/330)
- Facter splunk version [\#280](https://github.com/voxpupuli/puppet-splunk/issues/280)
- Splunk enterprise fact hangs partial install [\#238](https://github.com/voxpupuli/puppet-splunk/issues/238)

**Merged pull requests:**

- Allow up-to-date dependencies [\#318](https://github.com/voxpupuli/puppet-splunk/pull/318) ([smortex](https://github.com/smortex))

## [v9.0.0](https://github.com/voxpupuli/puppet-splunk/tree/v9.0.0) (2021-08-09)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v8.0.0...v9.0.0)

**Breaking changes:**

- Drop Puppet 5, add Puppet 7 support [\#313](https://github.com/voxpupuli/puppet-splunk/pull/313) ([smortex](https://github.com/smortex))
- Drop EOL Debian 8; Add Debian 9/10 support [\#306](https://github.com/voxpupuli/puppet-splunk/pull/306) ([bastelfreak](https://github.com/bastelfreak))
- Drop CentOS 6 support [\#305](https://github.com/voxpupuli/puppet-splunk/pull/305) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- puppet/archive: allow 5.x [\#309](https://github.com/voxpupuli/puppet-splunk/pull/309) ([bastelfreak](https://github.com/bastelfreak))
- Add Ubuntu 18.04/20.04 support [\#307](https://github.com/voxpupuli/puppet-splunk/pull/307) ([bastelfreak](https://github.com/bastelfreak))
- add option to manage net-tools package [\#303](https://github.com/voxpupuli/puppet-splunk/pull/303) ([mcmartins](https://github.com/mcmartins))
- Add support for FreeBSD [\#282](https://github.com/voxpupuli/puppet-splunk/pull/282) ([martijndegouw](https://github.com/martijndegouw))
- Add support for OpenSUSE [\#281](https://github.com/voxpupuli/puppet-splunk/pull/281) ([martijndegouw](https://github.com/martijndegouw))
- Add ability to override default-host configuration [\#279](https://github.com/voxpupuli/puppet-splunk/pull/279) ([dave-pollock](https://github.com/dave-pollock))

**Fixed bugs:**

- Corrupt MSI installer [\#311](https://github.com/voxpupuli/puppet-splunk/issues/311)
- Fix systemd service file locations to documented locations [\#297](https://github.com/voxpupuli/puppet-splunk/pull/297) ([martijndegouw](https://github.com/martijndegouw))
- Workaround a change in behavior of ensure\_packages with stdlib [\#296](https://github.com/voxpupuli/puppet-splunk/pull/296) ([martijndegouw](https://github.com/martijndegouw))
- Check if splunk forwarder was already installed when seeding password. [\#278](https://github.com/voxpupuli/puppet-splunk/pull/278) ([mattk42](https://github.com/mattk42))

**Closed issues:**

- child class splunk::forwarder::password::seed has a typo in the fact [\#289](https://github.com/voxpupuli/puppet-splunk/issues/289)
- Hard coded dependency net-tools [\#275](https://github.com/voxpupuli/puppet-splunk/issues/275)
- Cant figure out how to set the index that splunk-forwarder sends to [\#205](https://github.com/voxpupuli/puppet-splunk/issues/205)

**Merged pull requests:**

- Allow latest dependencies [\#316](https://github.com/voxpupuli/puppet-splunk/pull/316) ([bastelfreak](https://github.com/bastelfreak))
- update puppet-strings documentation [\#302](https://github.com/voxpupuli/puppet-splunk/pull/302) ([bastelfreak](https://github.com/bastelfreak))
- Use a more concise rspec-puppet syntax [\#301](https://github.com/voxpupuli/puppet-splunk/pull/301) ([ekohl](https://github.com/ekohl))
- adopt test to newer rspec-puppet syntax [\#300](https://github.com/voxpupuli/puppet-splunk/pull/300) ([bastelfreak](https://github.com/bastelfreak))
- Correct web\_httpport field name [\#299](https://github.com/voxpupuli/puppet-splunk/pull/299) ([thebeanogamer](https://github.com/thebeanogamer))
- modulesync 3.0.0 & puppet-lint updates [\#293](https://github.com/voxpupuli/puppet-splunk/pull/293) ([bastelfreak](https://github.com/bastelfreak))
- \(docs\) cleaned up the TBD sections. [\#291](https://github.com/voxpupuli/puppet-splunk/pull/291) ([binford2k](https://github.com/binford2k))
- Support ppc64le [\#290](https://github.com/voxpupuli/puppet-splunk/pull/290) ([treydock](https://github.com/treydock))
- changing fact name [\#288](https://github.com/voxpupuli/puppet-splunk/pull/288) ([jose-lmax](https://github.com/jose-lmax))
- Use voxpupuli-acceptance [\#283](https://github.com/voxpupuli/puppet-splunk/pull/283) ([ekohl](https://github.com/ekohl))

## [v8.0.0](https://github.com/voxpupuli/puppet-splunk/tree/v8.0.0) (2020-02-12)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v7.3.0...v8.0.0)

**Breaking changes:**

- drop Ubuntu 14.04 support [\#267](https://github.com/voxpupuli/puppet-splunk/pull/267) ([bastelfreak](https://github.com/bastelfreak))
- Add 7.2 support and refactor module [\#215](https://github.com/voxpupuli/puppet-splunk/pull/215) ([nick-markowski](https://github.com/nick-markowski))
- modulesync 2.5.1 and drop puppet 4 [\#211](https://github.com/voxpupuli/puppet-splunk/pull/211) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Support upgrading splunk forwarding and accepting ToS [\#269](https://github.com/voxpupuli/puppet-splunk/pull/269) ([treydock](https://github.com/treydock))
- Setup admin account through user-seed.conf [\#242](https://github.com/voxpupuli/puppet-splunk/pull/242) ([ody](https://github.com/ody))
- Set user and group for addon installation [\#241](https://github.com/voxpupuli/puppet-splunk/pull/241) ([ody](https://github.com/ody))
- Refactor defined type Splunk::Addon [\#224](https://github.com/voxpupuli/puppet-splunk/pull/224) ([ody](https://github.com/ody))
- Compare decrypted values to see if they are insync [\#221](https://github.com/voxpupuli/puppet-splunk/pull/221) ([alexjfisher](https://github.com/alexjfisher))
- Add the ability to override package\_source [\#209](https://github.com/voxpupuli/puppet-splunk/pull/209) ([beezly](https://github.com/beezly))

**Fixed bugs:**

- Purging of inputs and outputs don't work on forwarder [\#157](https://github.com/voxpupuli/puppet-splunk/issues/157)
- Fix flaky acceptance tests [\#260](https://github.com/voxpupuli/puppet-splunk/pull/260) ([ody](https://github.com/ody))
- Windows fixes [\#234](https://github.com/voxpupuli/puppet-splunk/pull/234) ([kreeuwijk](https://github.com/kreeuwijk))
- Fix purging of resources [\#220](https://github.com/voxpupuli/puppet-splunk/pull/220) ([alexjfisher](https://github.com/alexjfisher))

**Closed issues:**

- Install package updates happen before service changes [\#263](https://github.com/voxpupuli/puppet-splunk/issues/263)
- Install of systemd unit file doesn't actually work [\#262](https://github.com/voxpupuli/puppet-splunk/issues/262)
- How to point splunk forwarder to a deploymentserver which listening on 8089?  [\#248](https://github.com/voxpupuli/puppet-splunk/issues/248)
- Error with ini\_file autoload [\#239](https://github.com/voxpupuli/puppet-splunk/issues/239)
- I think $service\_name is missing under params.pp. I think we need to add $service\_name = \[ 'splunk', 'splunkd', 'splunkweb' \] [\#229](https://github.com/voxpupuli/puppet-splunk/issues/229)
- Setting up splunk admin could be easier [\#226](https://github.com/voxpupuli/puppet-splunk/issues/226)
- Optionally manage splunk user/group [\#223](https://github.com/voxpupuli/puppet-splunk/issues/223)
- Splunk\_serverclass exists but is not documented [\#218](https://github.com/voxpupuli/puppet-splunk/issues/218)
- Module does not work with Splunk 7.1.x or 7.2.x [\#213](https://github.com/voxpupuli/puppet-splunk/issues/213)
- Unable to create symlink [\#212](https://github.com/voxpupuli/puppet-splunk/issues/212)
- Unable to set user for forwarder service [\#210](https://github.com/voxpupuli/puppet-splunk/issues/210)
- Strange issues during unit tests with Puppet 5.3.2 [\#156](https://github.com/voxpupuli/puppet-splunk/issues/156)

**Merged pull requests:**

- allow puppetlabs/inifile 4.x [\#268](https://github.com/voxpupuli/puppet-splunk/pull/268) ([bastelfreak](https://github.com/bastelfreak))
- Fix systemd support and service subclass ordering [\#265](https://github.com/voxpupuli/puppet-splunk/pull/265) ([treydock](https://github.com/treydock))
- Clean up acceptance spec helper [\#261](https://github.com/voxpupuli/puppet-splunk/pull/261) ([ekohl](https://github.com/ekohl))
- add secret\_file parameter to Windows [\#254](https://github.com/voxpupuli/puppet-splunk/pull/254) ([kreeuwijk](https://github.com/kreeuwijk))
- Allow puppetlabs/concat 6.x and puppet/archive 4.x [\#240](https://github.com/voxpupuli/puppet-splunk/pull/240) ([alexjfisher](https://github.com/alexjfisher))
- Allow `puppetlabs/stdlib` 6.x [\#236](https://github.com/voxpupuli/puppet-splunk/pull/236) ([alexjfisher](https://github.com/alexjfisher))
- fix osfamily = 'windows' and kernel = 'windows' in lowercase [\#233](https://github.com/voxpupuli/puppet-splunk/pull/233) ([kreeuwijk](https://github.com/kreeuwijk))
- Allow puppetlabs/inifile 3.x [\#231](https://github.com/voxpupuli/puppet-splunk/pull/231) ([dhoppe](https://github.com/dhoppe))
- Documentation style updates [\#227](https://github.com/voxpupuli/puppet-splunk/pull/227) ([ody](https://github.com/ody))
- Address post-merge comments on PR \#224 [\#225](https://github.com/voxpupuli/puppet-splunk/pull/225) ([ody](https://github.com/ody))
- Add splunk\_serverclass documentation to README [\#219](https://github.com/voxpupuli/puppet-splunk/pull/219) ([rbclark](https://github.com/rbclark))
- Add documentation for two file types. [\#207](https://github.com/voxpupuli/puppet-splunk/pull/207) ([dafydd2277](https://github.com/dafydd2277))
- Add splunkforwarder\_version fact [\#206](https://github.com/voxpupuli/puppet-splunk/pull/206) ([treydock](https://github.com/treydock))

## [v7.3.0](https://github.com/voxpupuli/puppet-splunk/tree/v7.3.0) (2018-10-19)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v7.2.1...v7.3.0)

**Implemented enhancements:**

- Make splunk\_user configurable. [\#195](https://github.com/voxpupuli/puppet-splunk/pull/195) ([mdwheele](https://github.com/mdwheele))

**Fixed bugs:**

- file\_path not set for splunkforwarder\_limits resource [\#202](https://github.com/voxpupuli/puppet-splunk/issues/202)
- Fixes \#202 [\#203](https://github.com/voxpupuli/puppet-splunk/pull/203) ([Renelast](https://github.com/Renelast))
- Improve ftr license agreement [\#199](https://github.com/voxpupuli/puppet-splunk/pull/199) ([Joshua-Snapp](https://github.com/Joshua-Snapp))

**Merged pull requests:**

- Allow empty local and outputs files to keep centralized Splunk happier. [\#201](https://github.com/voxpupuli/puppet-splunk/pull/201) ([gregswift](https://github.com/gregswift))
- modulesync 2.2.0 and allow puppet 6.x [\#200](https://github.com/voxpupuli/puppet-splunk/pull/200) ([bastelfreak](https://github.com/bastelfreak))
- Allow puppetlabs/stdlib 5.x and puppetlabs/concat 5.x [\#193](https://github.com/voxpupuli/puppet-splunk/pull/193) ([bastelfreak](https://github.com/bastelfreak))

## [v7.2.1](https://github.com/voxpupuli/puppet-splunk/tree/v7.2.1) (2018-08-20)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v7.2.0...v7.2.1)

**Fixed bugs:**

- Add --no-prompt to the initial splunk start \(required on 7.1.X\) [\#191](https://github.com/voxpupuli/puppet-splunk/pull/191) ([ralfbosz](https://github.com/ralfbosz))

**Closed issues:**

- Module does not seem to work with splunkforwarder 7.X [\#186](https://github.com/voxpupuli/puppet-splunk/issues/186)

## [v7.2.0](https://github.com/voxpupuli/puppet-splunk/tree/v7.2.0) (2018-06-14)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v7.1.0...v7.2.0)

**Implemented enhancements:**

- New Custom Type For Managing .meta files [\#176](https://github.com/voxpupuli/puppet-splunk/pull/176) ([michaelweiser](https://github.com/michaelweiser))

**Fixed bugs:**

- fix unknown variable: staged\_package [\#179](https://github.com/voxpupuli/puppet-splunk/pull/179) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Bump dependency constraint for the puppetlabs/inifile module  [\#172](https://github.com/voxpupuli/puppet-splunk/issues/172)

**Merged pull requests:**

- Allow this module to be installed with puppet-archive 3.0.0 [\#184](https://github.com/voxpupuli/puppet-splunk/pull/184) ([mpdude](https://github.com/mpdude))
- Allow forwarder to fully support alternate install directories [\#183](https://github.com/voxpupuli/puppet-splunk/pull/183) ([Nekototori](https://github.com/Nekototori))
- drop EOL OSs; fix puppet version range [\#182](https://github.com/voxpupuli/puppet-splunk/pull/182) ([bastelfreak](https://github.com/bastelfreak))
- Rely on beaker-hostgenerator for docker nodesets [\#181](https://github.com/voxpupuli/puppet-splunk/pull/181) ([ekohl](https://github.com/ekohl))
- bump puppet to latest supported version 4.10.0 [\#178](https://github.com/voxpupuli/puppet-splunk/pull/178) ([bastelfreak](https://github.com/bastelfreak))
- Remove unsupported use of proc in title patterns [\#174](https://github.com/voxpupuli/puppet-splunk/pull/174) ([treydock](https://github.com/treydock))
- \(maint\) Bumping inifile dependency from \> 2.0.0 to \> 3.0.0 [\#173](https://github.com/voxpupuli/puppet-splunk/pull/173) ([TraGicCode](https://github.com/TraGicCode))

## [v7.1.0](https://github.com/voxpupuli/puppet-splunk/tree/v7.1.0) (2017-12-09)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v7.0.0...v7.1.0)

**Implemented enhancements:**

- Update splunk installer directory structure + enable automated tests [\#149](https://github.com/voxpupuli/puppet-splunk/issues/149)

**Fixed bugs:**

- Error on using ini\_setting [\#77](https://github.com/voxpupuli/puppet-splunk/issues/77)
- The splunk::forwarder::purge\_inputs generates error  [\#69](https://github.com/voxpupuli/puppet-splunk/issues/69)

**Closed issues:**

- Agent run fails: no parameter named 'purge\_forwarder\_deploymentclient'  [\#158](https://github.com/voxpupuli/puppet-splunk/issues/158)
- Allow /opt/splunkforwarder/var/run/splunk splunkd.pid to run as splunk [\#154](https://github.com/voxpupuli/puppet-splunk/issues/154)
- Erro deploying Splunk both Server and Forwarder [\#76](https://github.com/voxpupuli/puppet-splunk/issues/76)
- Need a `splunkforwarder_input` defined resource type [\#75](https://github.com/voxpupuli/puppet-splunk/issues/75)

**Merged pull requests:**

- Update README [\#162](https://github.com/voxpupuli/puppet-splunk/pull/162) ([arjenz](https://github.com/arjenz))
- replace validate\_string with assert\_type [\#161](https://github.com/voxpupuli/puppet-splunk/pull/161) ([bastelfreak](https://github.com/bastelfreak))

## [v7.0.0](https://github.com/voxpupuli/puppet-splunk/tree/v7.0.0) (2017-10-04)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v6.3.1...v7.0.0)

**Breaking changes:**

- BREAKING: Ability to download from download.splunk.com [\#150](https://github.com/voxpupuli/puppet-splunk/pull/150) ([TraGicCode](https://github.com/TraGicCode))

**Implemented enhancements:**

- Add serverclass type [\#147](https://github.com/voxpupuli/puppet-splunk/pull/147) ([TraGicCode](https://github.com/TraGicCode))

**Closed issues:**

- Create a type to manage deployment server "ServerClasses" [\#146](https://github.com/voxpupuli/puppet-splunk/issues/146)

**Merged pull requests:**

- v7.0.0 Release [\#152](https://github.com/voxpupuli/puppet-splunk/pull/152) ([TraGicCode](https://github.com/TraGicCode))

## [v6.3.1](https://github.com/voxpupuli/puppet-splunk/tree/v6.3.1) (2017-09-26)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v6.3.0...v6.3.1)

**Fixed bugs:**

- Fix config file location for splunkforwarder\_deploymentclient, deployment client, and alert\_actions. [\#144](https://github.com/voxpupuli/puppet-splunk/pull/144) ([treydock](https://github.com/treydock))

**Merged pull requests:**

- Release v6.3.1 [\#145](https://github.com/voxpupuli/puppet-splunk/pull/145) ([TraGicCode](https://github.com/TraGicCode))

## [v6.3.0](https://github.com/voxpupuli/puppet-splunk/tree/v6.3.0) (2017-09-25)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v6.2.0...v6.3.0)

**Implemented enhancements:**

- Add splunk\_alert\_actions type. [\#142](https://github.com/voxpupuli/puppet-splunk/pull/142) ([TraGicCode](https://github.com/TraGicCode))
- Add deploymentclient types [\#141](https://github.com/voxpupuli/puppet-splunk/pull/141) ([TraGicCode](https://github.com/TraGicCode))
- Add Purge + File Management for splunk\_uiprefs [\#124](https://github.com/voxpupuli/puppet-splunk/pull/124) ([treydock](https://github.com/treydock))

**Closed issues:**

- Add Windows Server 2016 + Ubuntu 16.04 to Supported OS's [\#137](https://github.com/voxpupuli/puppet-splunk/issues/137)

**Merged pull requests:**

- v6.3.0 release [\#143](https://github.com/voxpupuli/puppet-splunk/pull/143) ([TraGicCode](https://github.com/TraGicCode))

## [v6.2.0](https://github.com/voxpupuli/puppet-splunk/tree/v6.2.0) (2017-09-24)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v6.1.0...v6.2.0)

**Implemented enhancements:**

- Replace Staging with archive module [\#127](https://github.com/voxpupuli/puppet-splunk/issues/127)

**Closed issues:**

- Evaluation Error: Unknown variable: 'splunk::params::forwarder\_install\_options' [\#97](https://github.com/voxpupuli/puppet-splunk/issues/97)

**Merged pull requests:**

- 6.2.0 Release [\#139](https://github.com/voxpupuli/puppet-splunk/pull/139) ([TraGicCode](https://github.com/TraGicCode))
- Added ubuntu 16.04 & 2016 + 2008R2 support. [\#138](https://github.com/voxpupuli/puppet-splunk/pull/138) ([TraGicCode](https://github.com/TraGicCode))
- Replace staging module with archive module [\#128](https://github.com/voxpupuli/puppet-splunk/pull/128) ([TraGicCode](https://github.com/TraGicCode))

## [v6.1.0](https://github.com/voxpupuli/puppet-splunk/tree/v6.1.0) (2017-09-20)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v6.0.0...v6.1.0)

**Implemented enhancements:**

- Ability to manage ui-prefs.conf [\#103](https://github.com/voxpupuli/puppet-splunk/issues/103)
- Added splunkforwarder\_server and splunkforwarder\_limits providers/types. [\#118](https://github.com/voxpupuli/puppet-splunk/pull/118) ([nicholaspearson](https://github.com/nicholaspearson))
- Allow redirecting of settings into custom contexts [\#87](https://github.com/voxpupuli/puppet-splunk/pull/87) ([michaelweiser](https://github.com/michaelweiser))

**Fixed bugs:**

- splunkd\_port not defined for forwarder [\#133](https://github.com/voxpupuli/puppet-splunk/issues/133)
- concat dependency is missing from metadata.json [\#122](https://github.com/voxpupuli/puppet-splunk/issues/122)
- splunkforwarder\_server not working [\#121](https://github.com/voxpupuli/puppet-splunk/issues/121)
- Fix .conf file modes for Windows forwarders [\#114](https://github.com/voxpupuli/puppet-splunk/pull/114) ([natemccurdy](https://github.com/natemccurdy))
- Allow for installing packages from UNC paths on Windows [\#113](https://github.com/voxpupuli/puppet-splunk/pull/113) ([natemccurdy](https://github.com/natemccurdy))
- Fix resource ordering in splunk class so that splunk types will properly notify services [\#91](https://github.com/voxpupuli/puppet-splunk/pull/91) ([treydock](https://github.com/treydock))

**Closed issues:**

- Ruby load error when using splunk::forwarder on Windows [\#110](https://github.com/voxpupuli/puppet-splunk/issues/110)

**Merged pull requests:**

- Release v6.1.0 [\#135](https://github.com/voxpupuli/puppet-splunk/pull/135) ([TraGicCode](https://github.com/TraGicCode))
- SplunkForwarder has no concept of a splunkd\_port [\#134](https://github.com/voxpupuli/puppet-splunk/pull/134) ([TraGicCode](https://github.com/TraGicCode))
- Remove unused spec\_helper\_system.rb [\#132](https://github.com/voxpupuli/puppet-splunk/pull/132) ([wyardley](https://github.com/wyardley))
- SplunkForwarder has no concept of a server\_service.  [\#130](https://github.com/voxpupuli/puppet-splunk/pull/130) ([TraGicCode](https://github.com/TraGicCode))
- Update missing concat dependency in acceptance tests. [\#129](https://github.com/voxpupuli/puppet-splunk/pull/129) ([TraGicCode](https://github.com/TraGicCode))
- wire up splunkforwarder\_server type [\#126](https://github.com/voxpupuli/puppet-splunk/pull/126) ([alexcreek](https://github.com/alexcreek))
- Added missing concat dependency to metadata.json + .fixtures.yml [\#123](https://github.com/voxpupuli/puppet-splunk/pull/123) ([TraGicCode](https://github.com/TraGicCode))
- Fix typo in extension filename [\#117](https://github.com/voxpupuli/puppet-splunk/pull/117) ([gregoirefra](https://github.com/gregoirefra))
- This commit adds the pkg\_provider 'chocolatey' to the module [\#108](https://github.com/voxpupuli/puppet-splunk/pull/108) ([ralfbosz](https://github.com/ralfbosz))
- Ability to configure ui-prefs.conf [\#104](https://github.com/voxpupuli/puppet-splunk/pull/104) ([TraGicCode](https://github.com/TraGicCode))
- Set `forwarder_install_options` to be `undef` for OS other than Windows. [\#99](https://github.com/voxpupuli/puppet-splunk/pull/99) ([alexqyle](https://github.com/alexqyle))

## [v6.0.0](https://github.com/voxpupuli/puppet-splunk/tree/v6.0.0) (2017-05-25)

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/v5.1.0...v6.0.0)

**Fixed bugs:**

- Fix Windows Forwarder Installdir [\#102](https://github.com/voxpupuli/puppet-splunk/pull/102) ([TraGicCode](https://github.com/TraGicCode))

**Closed issues:**

- Support .conf files in non-standard locations [\#88](https://github.com/voxpupuli/puppet-splunk/issues/88)
- Warnings produced when splunk resources are in catalog [\#86](https://github.com/voxpupuli/puppet-splunk/issues/86)

**Merged pull requests:**

- Bump release for 6.0.0 [\#112](https://github.com/voxpupuli/puppet-splunk/pull/112) ([petems](https://github.com/petems))
- Add LICENSE file [\#109](https://github.com/voxpupuli/puppet-splunk/pull/109) ([alexjfisher](https://github.com/alexjfisher))
- This commit sets the splunk\_user for Windows to 'administrator' [\#107](https://github.com/voxpupuli/puppet-splunk/pull/107) ([ralfbosz](https://github.com/ralfbosz))
- Lint fixes [\#101](https://github.com/voxpupuli/puppet-splunk/pull/101) ([treydock](https://github.com/treydock))
- types: Fix purging when section contains '//' [\#96](https://github.com/voxpupuli/puppet-splunk/pull/96) ([jameslikeslinux](https://github.com/jameslikeslinux))
- splunk\_config: Only load other splunk types [\#95](https://github.com/voxpupuli/puppet-splunk/pull/95) ([jameslikeslinux](https://github.com/jameslikeslinux))
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

[Full Changelog](https://github.com/voxpupuli/puppet-splunk/compare/b61fce61714ec54dafd9364a4f102647cd5cf185...0.2.0)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
