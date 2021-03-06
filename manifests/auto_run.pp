# Runs Munki after it has been installed

class munki::auto_run {
  $auto_run_after_install = $munki::auto_run_after_install
  $munkitools_version     = $munki::munkitools_version

  File {
    ensure => 'present',
    owner  => 0,
    group  => 0,
  }

  if $auto_run_after_install == true {
    $launchd = {
      'Disabled'         => false,
      'Label'            => 'org.munki.auto_run',
      'ProgramArguments' => [
        '/usr/local/munki/auto_run.sh'
      ],
      'RunAtLoad'        => true
    }

    if !defined(File['/usr/local/munki']){
      file {'/usr/local/munki':
        ensure => directory
      }
    }

    file {'/usr/local/munki/auto_run.sh':
      mode   => '0755',
      source => 'puppet:///modules/munki/auto_run.sh'
    }

    -> file {'/Library/LaunchDaemons/org.munki.auto_run.plist':
      mode    => '0755',
      content => plist($launchd)
    }

    -> service {'org.munki.auto_run':
      ensure => 'running',
      enable => true,
    }
  }
}
