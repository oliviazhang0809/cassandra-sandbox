# == Class: cassandra::config
class cassandra::config {
  $listen_address = $::ipaddress_eth1
  $cluster_name = $::cluster_name

  concat{'/etc/dse/cassandra/cassandra.yaml':
    owner  => 'cassandra',
    group  => 'cassandra',
    mode   => '0644',
    notify => Class[ 'cassandra::service' ],
  }

  concat::fragment{'cassandra_config':
      target  => '/etc/dse/cassandra/cassandra.yaml',
      content => template('cassandra/cassandra.yaml.erb'),
  }

  Concat::Fragment <<| tag == 'seedhost' |>> {
      target => '/etc/dse/cassandra/cassandra.yaml'
  }
  
  # ensure java version is 7 or higher
  exec { 'set_java_7':
    command => 'sudo alternatives --set java /opt/jdk1.7.0_67/bin/java',
    unless => "alternatives --display java | grep \"link currently points to /opt/jdk1.7.0_67/bin/java\"",
  }
}
