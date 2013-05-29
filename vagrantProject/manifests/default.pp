#make sure the puppet is installed on the .box otherwise rest of the puppet provisioning will not function
group { "puppet": 
	ensure => "present", 
}


notify { 'Installing required packages.': }

package { ['git-core', 'openssh-server', 'fabric', 'python-pip', 'vnc4server', 'imagemagick', 'optipng', 'groovy', 'ia32-libs']:
       provider=>'apt',
       ensure=>'installed',
}

notify { 'Finished installing required packages.': }
