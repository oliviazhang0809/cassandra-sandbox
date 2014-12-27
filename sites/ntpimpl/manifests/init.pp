# Class: ntpimpl
#
# This class implements ntp module
#
class ntpimpl (
  $panic = hiera('panic'),
  $driftfile = hiera('driftfile'),
  $preferred_servers = hiera('preferred_servers'),
  $servers = hiera('servers')
  ) {

  class { 'ntp':
    panic             => $panic,
    driftfile         => $driftfile,
    preferred_servers => $preferred_servers,
    servers           => $servers,
  }
}
