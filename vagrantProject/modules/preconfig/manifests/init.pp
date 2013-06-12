class preconfig {
	exec { 'osupdate':
		command => 'apt-get update',
    before => Exec['os-dist-upgrade'],  #Capital Exec is a reference to another resource
	}

  exec{ 'os-dist-upgrade':
    command => 'ls',#apt-get -y dist-upgrade',
  }
}