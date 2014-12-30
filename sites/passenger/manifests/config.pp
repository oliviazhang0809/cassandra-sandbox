# == Class: passenger::config
class passenger::config {

  $deactivated_master = 'chkconfig puppetmaster off'

  file { 'rack_config':
      ensure => present,
      source => '/usr/share/puppet/ext/rack/config.ru',
      path   => '/usr/share/puppet/rack/puppetmasterd/config.ru',
      owner  => 'puppet',
      group  => 'puppet',
      notify => Service['httpd'],
  }

  file { 'apache_config':
      ensure  => present,
      content => template('passenger/puppetmaster.conf.erb'),
      path    => '/etc/httpd/conf.d/puppetmaster.conf',
      owner   => 'puppet',
      group   => 'puppet',
      notify  => Service['httpd'],
  }

  service { 'puppetmaster':
    ensure     => stopped,
    hasstatus  => true,
    hasrestart => true,
    enable     => false,
  }

  exec {'deactivate_puppetmaster':
    command => $deactivated_master,
  }
}
