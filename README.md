Steps: 

- install vagrant
- cd gitSplitTest\vagrantProject

- Add the vagrant base box 
-- Copy https://s3-us-west-2.amazonaws.com/squishy.vagrant-boxes/precise64_squishy_2013-02-09.box to gitSplitTest\vms
-- $ vagrant box add grailsdev ..\vms\precise64_squishy_2013-02-09.box

- vagrant up

- Destroying all traces of the vms
vagrant destroy -f 

- Removing the vagrant box:
vagrant box remove grailsdev virtualbox

