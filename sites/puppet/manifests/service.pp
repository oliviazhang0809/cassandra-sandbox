# == Class: puppet::service
# DO NO CALL DIRECTLY
class puppet::service {

  service { 'puppet':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }
}
