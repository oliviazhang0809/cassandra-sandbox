# == Class: puppet::install
# DO NO CALL DIRECTLY
class puppet::install {
  package { 'puppet':
    ensure => $puppet::ensure,
  }
}
