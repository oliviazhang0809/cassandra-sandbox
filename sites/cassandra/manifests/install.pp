# == Class: cassandra::install
# DO NO CALL DIRECTLY
class cassandra::install {

  # [ install dse-full ]
  package { 'dse-full':
    ensure => '4.5.3-1',
  }
}
