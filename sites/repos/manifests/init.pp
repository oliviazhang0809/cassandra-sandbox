# == Class: repos
#
# This class loads the relevant distribution-specific package repository
# manifests and would be the place to configure any other custom repos you
# may want.
#

class repos {
  $os_release_major_version = regsubst($::operatingsystemrelease, '^(\d+).*$', '\1')

  file { 'puppetlabs.repo':
    ensure  => present,
    path    => '/etc/yum.repos.d/puppetlabs.repo',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('repos/puppetlabs.repo.erb'),
  }

  exec { 'yum_makecache':
    command     => '/usr/bin/yum makecache',
    subscribe   => File[ 'puppetlabs.repo' ],
    refreshonly => true,
    timeout     => 1800,
  }
}
