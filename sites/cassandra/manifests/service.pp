# == Class: cassandra::service
# DO NO CALL DIRECTLY
class cassandra::service {

  service { 'dse':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
