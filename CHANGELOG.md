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
