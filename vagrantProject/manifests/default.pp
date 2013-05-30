#make sure the puppet is installed on the .box otherwise rest of the puppet provisioning will not function
group { "puppet": 
	ensure => "present", 
}

#Need to set the path
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
#exec { 'apt-get update':
#  command => '/usr/bin/apt-get update',
#}

#exec { 'apt-get -y dist-upgrade':
#  command => '/usr/bin/apt-get -y dist-upgrade',
#}

#Some OS specific stuff
#case $operatingsystem {
#      centos, redhat: { $apache = "httpd" }
#      debian, ubuntu: { $apache = "apache2" }
#      default: { fail("Unrecognized operating system for webserver") }
#    }
#}

#package {'apache':
#      name   => $apache,
#      ensure => installed,
#}


class appServer {
     grails { "grails-2.2.2":
        version => '2.2.2',
        destination => '/opt',
    }
}

notify { 'Installing required OS packages.': }
node default {
	include appServer
}
#package { ['git-core', 'openssh-server', 'fabric', 'python-pip', 'vnc4server', 'imagemagick', 'optipng', 'groovy', 'ia32-libs']:
 #      provider=>'apt',
 #      ensure=>'installed',
#}


notify { 'Finished installing required OS packages.': }