#make sure the puppet is installed on the .box otherwise rest of the puppet provisioning will not function
group { "puppet": 
	ensure => "present", 
}

#Set the dfaults for all execs
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ], logoutput => 'true' }

# create a new run stage to ensure certain modules are included first
stage { 'pre':
  before => Stage['main']
}

#Stages the class preConfig to run in the pre stage
#class { 'preConfig':
 # stage => 'pre'
#}

#Puppet will automatically guess the packaging format that you are using based on the platform you are on, but you can override it using the provider parameter
package { ['wget', 'unzip', 'git-core', 'openssh-server', 'curl']:
       ensure=>'installed',
}

#Example using some OS specific stuff
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

#Grails aplication stack
class grailsStack {
     # class { 'java': version => '7u21-0~webupd8~0', }
      class { 'grails': version => '2.2.2', destination => '/opt',}
}


#Installs java
class java($version = '7u21-0~webupd8~0') {
  package { "python-software-properties": }
  exec { "add-apt-repository-oracle":
    command => "/usr/bin/add-apt-repository -y ppa:webupd8team/java",
    notify => Exec["apt_update"]
  }
  exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
    'set-java-home':
      command => 'echo \'export JAVA_HOME="/usr/lib/jvm/java-7-oracle/"\' > /etc/profile.d/java_home.sh';
    'apt_update':
      command => 'apt-get update';
  }
  package { 'oracle-java7-installer':
    ensure  => "${version}",
    require => [Exec['add-apt-repository-oracle'], Exec['set-licence-selected'], Exec['set-licence-seen']],
    before  => Exec['set-java-home'],
  }
}


class grails($version, $destination, $user = "root"){
  exec {'install-gvm':
    command => 'curl -s get.gvmtool.net | bash',
  }

  exec {'source-gvm':
    #dont know why we have to use bash -c
    command => 'bash -c source ~/.gvm/bin/gvm-init.sh',  
  }
 
  exec { "install-grails":
    command => "bash -c gvm install grails $version",
  }
 
  Exec['install-gvm'] -> Exec['source-gvm'] -> Exec['install-grails']
}

node default {
	include grailsStack
  
}


