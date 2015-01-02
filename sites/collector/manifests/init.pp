# == Class: Collector
#
# This class collect exported resources and store them into puppetDB
#
class collector (
  $box_type = hiera('box_type')
  ){
  define exported_vars::set (
    $value = '',
    $timestamp = generate('/bin/date', '+%Y%d%m_%H:%M:%S'),
    ){
      @@concat::fragment { "${::hostname}_${timestamp}_seed_hostname":
        content => "          - seeds: ${value}\n",
        tag     => "${::cluster_name}-seedhost",
  }
}

  $mq_var = 'seedhost'
  $seed_ip = $box_type ? {
    0 => $::ipaddress_eth1,
    1 => $::ipaddress,
  }

  exported_vars::set { $mq_var:
    value => $seed_ip,
  }
}
