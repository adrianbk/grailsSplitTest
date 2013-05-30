#make sure the puppet is installed on the .box otherwise rest of the puppet provisioning will not function
include 'apt'

class { 'apt': }

#apt::source { 'puppetlabs':
	#location   => 'http://apt.puppetlabs.com',
	#repos      => 'main',
	#key        => '4BD6EC30',
	#key_server => 'pgp.mit.edu',
#}

group { "puppet": 
	ensure => "present", 
}

#exec { 'apt-get update':
#  command => '/usr/bin/apt-get update',
#}

#exec { 'apt-get -y dist-upgrade':
#  command => '/usr/bin/apt-get -y dist-upgrade',
#}


notify { 'Installing required packages.': }

#package { ['git-core', 'openssh-server', 'fabric', 'python-pip', 'vnc4server', 'imagemagick', 'optipng', 'groovy', 'ia32-libs']:
 #      provider=>'apt',
 #      ensure=>'installed',
#}

notify { 'Finished installing required packages.': }
