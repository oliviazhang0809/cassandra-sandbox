# == Class: cassandra::service
# DO NO CALL DIRECTLY
class cassandra::service {

  service { 'cassandra':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
