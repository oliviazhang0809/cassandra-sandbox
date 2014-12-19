# == Class: cassandra::config
class cassandra::config {
  $listen_address = $::ipaddress_eth1
  $seed_provider = hiera('seeds') ? {
    'x' => $::ipaddress,
    default => hiera('seeds')
  }
  
  # check cassandra.yaml
  file { 'cassandra.yaml':
    ensure  => present,
    content => template('cassandra/cassandra.yaml.erb'),
    path    => '/etc/dse/cassandra/cassandra.yaml',
    owner   => 'cassandra',
    group   => 'cassandra',
    mode    => '0644',
    notify  => Class[ 'cassandra::service' ],
  }
  
  # remove /var/lib/cassandra (do we need this?)
  file { [ '/var/lib/cassandra/commitlog', '/var/lib/cassandra/data', '/var/lib/cassandra/saved_caches' ]:
    ensure => absent,
    owner  => 'cassandra',
    group  => 'cassandra',
  }

  # ensure java version is 7 or higher
  exec { 'set_java_7':
    command => 'sudo alternatives --set java /opt/jdk1.7.0_71/bin/java',
  }
}
