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

node default {
	include grailsStack
}

#Grails aplication stack
class grailsStack {
	class {'installOsPackages':
		stage => first,
	}
	class { 'java':
	    binary          => 'jdk-7u11-linux-x64.tar.gz',
	    package_name    => 'jdk1.7.0_11',
	    stage           => main,
	}

	class { 'grails':
		version     => '2.2.2',
		destination => '/opt',
		stage       => main,
	}
}


#Installs java
class java($binary = 'jdk-7u11-linux-x64.tar.gz', $package_name = 'jdk1.7.0_11') {
    file { '/usr/lib/jvm/':
      ensure => directory,
    }
    file { "/usr/lib/jvm/${package_name}":
      ensure  => present,
      source  => "/vagrant/software/${binary}",
      require => File['/usr/lib/jvm/'],
      notify  => Exec['unpack-java'],
    }
    exec { 'unpack-java':
      command     => "tar zxf /vagrant/software/${binary}; mv ${package_name} ${package_name}-oracle",
      cwd         => '/usr/lib/jvm/',
      path        => '/bin',
      refreshonly => true,
      notify      => Exec['update-alternatives'],
    }
    exec { 'update-alternatives':
      command     => "update-alternatives --install /usr/bin/java java /usr/lib/jvm/${package_name}-oracle/jre/bin/java 1; update-alternatives --set java /usr/lib/jvm/${package_name}-oracle/jre/bin/java",
      cwd         => '/',
      refreshonly => true,
      notify      => File['set-java-home'],
    }

     file{ 'set-java-home':
        name    => "/etc/profile.d/java_variables.sh",
        content => "export JAVA_HOME=\"/usr/lib/jvm/${package_name}-oracle\"",
        ensure  => "present",
        mode    => '0755',
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
    file { 'download-grails':
        name          => "$destination/grails-$version.zip",
        ensure        => "present",
        source        => "/vagrant/software/grails-$version.zip",
        owner         => "$user",
        group         => "$user",
        mode          => '0755',
    }

    exec{ "unzip-grails" :
        cwd     => "$destination",
        command => "unzip grails-$version.zip",
        creates => "$destination/grails-$version",
    }

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
    #Resource order
    File['download-grails'] -> Exec['unzip-grails'] -> File['/etc/profile.d/grails_variables.sh']
}

