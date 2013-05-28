#make sure the puppet is installed on the .box otherwise rest of the puppet provisioning will not function


#aptitude vim gconf-editor fabric python-pip git-core openssh-server vnc4server imagemagick optipng groovy ia32-libs

group { "puppet": 
	ensure => "present" 
}

notify { 'Installing required packages.': }

package { ['git-core', 'openssh-server']:
       provider=>'apt',
       ensure=>'installed'
}

notify { 'Finished installing required packages.': }


#package { ['aptitude', 'git-core', 'openssh-server', 'vnc4server', 'imagemagick', 'optipng', 'groovy', 'ia32-libs']:
#      ensure => present,
#}