# == Class: passenger::install
# DO NO CALL DIRECTLY
class passenger::install (
  $rack_version = hiera('rack_version'),
  $passenger_version = hiera('passenger_version'),
  $httpd_version = hiera('httpd_version'),
  $ruby_devel_version = hiera('ruby_devel_version'),
  $libcurl_devel_version = hiera('libcurl_devel_version'),
  $rubygem_version = hiera('rubygem_version')
  ) {

  package { [ 'httpd', 'httpd-devel', 'mod_ssl' ]:
    #ensure   => $httpd_version,
    ensure   => 'installed',
  }

  package { 'ruby-devel':
    #ensure   => $ruby_devel_version,
    ensure   => 'installed',
  }

  package { 'libcurl-devel':
    #ensure   => $libcurl_devel_version,
    ensure   => 'installed',
  }

  package { 'rubygems':
    ensure => $rubygem_version,
    before => [ Package['rack'], Package['passenger'] ],
  }

  package { 'rack':
    ensure   => $rack_version,
    provider => gem,
  }

  package { 'passenger':
    ensure   => $passenger_version,
    provider => gem,
  }

  file { [ '/usr/share/puppet/rack', '/usr/share/puppet/rack/puppetmasterd', '/usr/share/puppet/rack/puppetmasterd/public', '/usr/share/puppet/rack/puppetmasterd/tmp' ]:
    ensure => 'directory',
  }
}
