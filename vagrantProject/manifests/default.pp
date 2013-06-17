#make sure the puppet is installed on the .box otherwise rest of the puppet provisioning will not function
group { "puppet": 
	ensure => "present", 
}

#Set the defaults for all exec commands
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ], logoutput => 'true' }

#Create three stages and define the resource order (main is the default included stage)
#OS type stuff and OS packages
stage { 'first': }
# last stage should cleanup/ do something unusual
stage { 'last': }

# Stage ordering
Stage['first'] -> Stage['main'] -> Stage['last']

#TODO uncomment to allow dist upgrade
#Stages the class preConfig to run in the pre stage
class { 'preConfig':
 stage => 'first'
}

class installOsPackages {
	#Puppet will automatically guess the packaging format that you are using based on the platform you are on, but you can override it using the provider parameter
	package { ['wget', 'unzip', 'git-core', 'openssh-server', 'curl']:
	   ensure=>'installed',
	}
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
	class {'installOsPackages':
		stage => first,
	}
	class { 'java':
	    version => '7u21-0~webupd8~0',
	    stage => main,
	}

	class { 'grails':
		version => '2.2.2',
		destination => '/opt',
		stage => main,
	}
}


#Installs java
class java($version = '7u21-0~webupd8~0') {
  package { 'python-software-properties': }
  exec { 'add-apt-repository-oracle':
	command => "/usr/bin/add-apt-repository -y ppa:webupd8team/java",
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
    }

  Package['python-software-properties'] -> Exec['add-apt-repository-oracle'] -> Exec["apt_update"] -> Exec['set-licence-selected']  -> Exec['set-licence-seen']
  -> Exec['set-java-home']  -> Package['oracle-java7-installer']
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
  }

  #exec{ "set-grails-paths" :
  #    command => 'echo \'export GRAILS_OPTS="-server -noverify -Xshare:off -Xms512M -Xmx1536M -XX:PermSize=512M"\' > /etc/profile.d/grails_opts.sh',
  #}

  file { "/etc/profile.d/grails_variables.sh":
	content => "export GRAILS_OPTS='-server -noverify -Xshare:off -Xmx1G -Xms256m -XX:MaxPermSize=512m';
	export GRAILS_HOME='${destination}/grails-${version}';
	PATH=\$PATH:\$GRAILS_HOME/bin:
	",
	ensure        => "present",
	owner         => "$user",
	group         => "$user",
	mode          => '0755',
  }

  #PATH=$PATH:/new_path:/another_new_path
  #export PATH
  #Resource order
  File['download-grails'] -> Exec['unzip-grails'] -> File['/etc/profile.d/grails_variables.sh']
}

node default {

	include grailsStack

}


