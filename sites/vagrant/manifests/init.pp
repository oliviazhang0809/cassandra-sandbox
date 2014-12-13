# == Class: vagrant
#
# This class is the place to fix minor Vagrant environment issues that may crop
# up with different base boxes.
#
#
class vagrant {

  user { 'puppet':
    ensure  => present,
    comment => 'Puppet',
    gid     => 'puppet',
    require => Group['puppet'],
  }

  group { 'puppet':
    ensure => present,
  }

  user { 'cassandra':
    ensure  => present,
    comment => 'cassandra',
    gid     => 'cassandra',
    require => Group['cassandra'],
  }

  group { 'cassandra':
    ensure => present,
  }
}
