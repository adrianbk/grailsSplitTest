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
class { 'preConfig':
  stage => 'pre'
}

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
      class { 'java': version => '7u21-0~webupd8~0', }
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

  if !defined(File["$destination"]) {
    file { "$destination":
      ensure => 'directory',
      owner => "$user",
      group => "$user",
      mode => '0755'
    }
  }

  if "$version" =~ /^1\.3\.[6-9]|^2\..*/ {
     $base_url = "http://dist.springframework.org.s3.amazonaws.com/release/GRAILS"
  }
  else {
     $base_url = "http://dist.codehaus.org/grails"
  }
  notify { "The base url for grails $version is '$base_url'": }

  file { 'download-grails':
    name          => "$destination/grails-$version.zip",
    ensure        => "present",
    source        => "/vagrant/software/grails-$version.zip",
    owner         => "$user",
    group         => "$user",
    mode          => '0755',
   # before        => Exec["unzip-grails"],
  }
  #TODO remove the above file resource and replace with wget OR have an option for either
 # exec{ "download-grails" :
  #  command => "/usr/bin/wget -d --output-document=$destination/grails-$version.zip $base_url/grails-$version.zip",
  #  before => Exec["unzip-grails"],
  #}

  exec{ "unzip-grails" :
    cwd => "$destination",
    command => "unzip grails-$version.zip",
    creates => "$destination/grails-$version",
  #  before => Exec["install-grails-$version"],
  }

  

  exec { "install-grails-$version":
    command => "unzip grails-$version.zip",
    cwd => "$destination",
    creates => "$destination/grails-$version",
   # before => Exec["set-grails-opts"],
  }

  exec{ "set-grails-opts" :
      command => 'echo \'export GRAILS_OPTS="-server -noverify -Xshare:off -Xms512M -Xmx1536M -XX:PermSize=512M"\' > /etc/profile.d/grails_opts.sh',
  }

#exec { "set-grails-home":
 # command => 'echo \'export GRAILS_HOME="-server -noverify -Xshare:off -Xms512M -Xmx1536M -XX:PermSize=512M"\' > /etc/profile.d/grails_home.sh',
#}

file { "/etc/profile.d/grails_home.sh" :
  content => "export GRAILS_HOME=$destination/$grails-$version",
}

 File['download-grails'] -> Exec["unzip-grails"] -> Exec["install-grails-$version"] -> Exec['set-grails-opts']
 exec{"install-gvm":
    command => 'curl -s get.gvmtool.net | bash'
 }
 exec{"install-grails":
  command => 'gvm install grails 2.2.1'

 }
 
 Exec['install-gvm'] -> Exec['install-grails']
}

node default {
	include grailsStack
  
}


