# == Class: passenger::service
# DO NO CALL DIRECTLY
class passenger::service {

  service { 'httpd':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }
}
