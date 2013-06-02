# Grails Split Test

## Intro (All WIP)

As a grails project grows, the number of tests and execution times increase. Longer execution on developer environments become painful and result in delayed feedback - particularly when the general consensus is to run entire test suites on developer environments before pushing code to a CI environment.
To alleviate this, running tests in parallel on developer environments can reduce test execution time. It is possible to run tests in parallel by creating multiple operating system processes however, this can become complicated when it comes to resources shared among tests running in parallel - consider the following local resources which are commonly shared by tests running in parallel: 
* A shared server that stubs out some external service - used by functional tests 
* Databases - Integration and functional tests

All leading to potential race conditions. Along with race conditions, it also becomes cumbersome to replicate such resources on developer environments. 

This project proides:

1. A base vagrant project used to spin up a configurable number of virtual machines (oracle vitual box) on which tests can be run in parallel.
* Provisioned using puppet, each VM has a grails stack can be easily provisioned with datastores and stub servers.
* Mounts the top level projectory on to each VM 

### Why Vagrant 
* portable - runs on any development OS
* Several provisioning options - puppet, chef sole, etc
* Supports several virtualization technoloies (VmWare, VirtualBox, Cloud)
* One command to spin up everything

Yes, virtual machines have performance drawbacks but HARDWARE is cheap - developer time is not!

2. A grails plugin which can split out grails tests and test phases depending on the number of machines created by vagrant. 
	

## Dependancies
1. Oracle virtual box 4.2.12 (https://www.virtualbox.org/wiki/Downloads)
2. Vagrant 2 (http://docs.vagrantup.com/v2/installation/)
3. A Vagrant base box (http://www.vagrantbox.es/)
* Ubuntu Ubuntu 12.04 LTS x86_64: https://s3-us-west-2.amazonaws.com/squishy.vagrant-boxes/precise64_squishy_2013-02-09.box

## Prerequisites 
* install vagrant
** cd gitSplitTest\vagrantProject

* Add the vagrant base box 
** Copy https://s3-us-west-2.amazonaws.com/squishy.vagrant-boxes/precise64_squishy_2013-02-09.box to gitSplitTest\vms
** $ vagrant box add grailsdev ..\vms\precise64_squishy_2013-02-09.box


## Usefull Vagrant commands
* Running vagrant
** Start up the VMs
** $ vagrant up

* Destroying all traces of the vms
** vagrant destroy -f 

* Removing the vagrant box:
** vagrant box remove grailsdev virtualbox

