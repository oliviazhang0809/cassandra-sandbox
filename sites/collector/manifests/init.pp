# == Class: Collector
#
# This class collect exported resources and store them into puppetDB
#
class collector (
  $box_type = hiera('box_type')
  ){

  $mq_var = 'seedhost'
  $seed_ip = $box_type ? {
    'virtualbox' => $::ipaddress_eth1,
    'openstack' => $::ipaddress,
  }

  collector::export { $mq_var:
    value => $seed_ip,
  }
}
