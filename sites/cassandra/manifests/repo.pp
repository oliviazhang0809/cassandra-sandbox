# == Class: cassandra::repo
class cassandra::repo {

  file { 'datastax.repo':
    ensure  => present,
    path    => '/etc/yum.repos.d/datastax.repo',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('cassandra/datastax.repo'),
  }

  # change 'https' => 'http'
  file { 'epel.repo':
    ensure  => present,
    path    => '/etc/yum.repos.d/epel.repo',
    owner   => 'cassandra',
    group   => 'cassandra',
    content => template('cassandra/epel.repo'),
  }

  # install cassandra - epel
  $package_source = 'http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'

  # get the package
  staging::file { 'epel-package':
    source   => $package_source,
  }

  package { 'epel':
    provider => 'rpm',
    source   => '/opt/staging/cassandra/epel-package',
    require  => Staging::File['epel-package'],
  }
}
