########################################
# Variables

$pg_password = 'password'

include stdlib
File { owner => 0, group => 0, mode => 0644 }

########################################
# apt-get - Update before any package 
# installs

exec { "apt-update":
    command => "/usr/bin/apt-get update"
}
Exec["apt-update"] -> Package <| |>

group { "puppet":
  ensure => "present",
}


########################################
# MOTD example

#File { owner => 0, group => 0, mode => 0644 }

#file { '/etc/motd':
  #content => "Welcome to your Vagrant-built virtual machine!
  #Managed by Puppet.\n"
#}

########################################
# NGINX example config

#class { 'nginx': }

#nginx::resource::upstream { 'puppet_rack_app':
  #ensure  => present,
  #members => [
    #'localhost:3000', 
    #],
#}

#nginx::resource::vhost { 'rack.puppetlabs.com':
  #ensure   => present,
  #proxy  => 'http://puppet_rack_app',
#}

########################################
# Postgres install and config

class { 'postgresql::server':
  config_hash => {
    'ip_mask_deny_postgres_user' => '0.0.0.0/32',
    'ip_mask_allow_all_users'    => '0.0.0.0/0',
    'listen_addresses'           => '*',
    'ipv4acls'                   => ['hostssl all johndoe 192.168.0.0/24 cert'],
    'postgres_password'          => $pg_password,
  },
}

package {'postgresql-server-dev-all':
}

postgresql::db { 'solrpanl_development':
  user     => 'solrpanl',
  password => 'password',
}

########################################
# Ruby

class { ruby: 
  version => '1.9.3-p392',
}

########################################
# Ruby/Bundler
# Make sure bundled gems are up to date

package { 'bundler':
  ensure   => present,
  provider => 'gem',
  require  => Class['ruby']
}

$command = "bundle install"

exec { "bundle install /vagrant/app":
  command     => $command,
  cwd         => '/vagrant',
  path        => "/bin:/usr/bin:/usr/local/bin",
  unless      => 'bundle check',
  require     => [Package['bundler'], Package['postgresql-server-dev-all']],
  logoutput   => on_failure,
  environment => "HOME='/vagrant/app'",
}

########################################
# Bootstrap database

exec { "rake db:migrate":
  command => "bundle exec rake db:migrate",
  cwd     => '/vagrant/app',
  path    => "/bin:/usr/bin:/usr/local/bin",
  require => [Exec["bundle install /vagrant/app"], Postgresql::Db['solrpanl_development']],
}

########################################
# Start the Rails server
# TODO: replace with thin? 
#       better tests to see if it's running?
#       vagrant aware rake tasks for migration/test/restart

exec { "rails server":
  command => "rails s &",
  cwd     => '/vagrant/app',
  path    => "/vagrant/script:/bin:/usr/bin:/usr/local/bin",
  require => [Exec["rake db:migrate"]],
}

