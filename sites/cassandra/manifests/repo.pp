# == Class: cassandra::repo
class cassandra::repo {

  file { 'datastax.repo':
    ensure  => present,
    path    => '/etc/yum.repos.d/datastax.repo',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => hiera('datastax.repo'),
  }

  # change 'https' => 'http'
  file { 'epel.repo':
    ensure  => present,
    path    => '/etc/yum.repos.d/epel.repo',
    owner   => 'cassandra',
    group   => 'cassandra',
    content => hiera('epel.repo'),
  }
  
  # install cassandra - epel
  package { 'epel-release-6-8':
    ensure   => present,
    source   => 'http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm',
    provider => rpm,
  }
}
