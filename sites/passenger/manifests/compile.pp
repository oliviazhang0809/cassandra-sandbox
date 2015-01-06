# == Class: passenger::compile
class passenger::compile {

  exec {'compile-passenger':
    command   => 'passenger-install-apache2-module -a',
    logoutput => on_failure,
    timeout   => 0,
    unless => "ls /etc/httpd/conf.d | grep 'puppetmaster'",
  }
}
