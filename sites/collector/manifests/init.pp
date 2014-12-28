class collector (
  $box_type = hiera('box_type')
  ){
  define exported_vars::set (
    $value = '',
    ){
      @@concat::fragment {'seed_hostname':
        content => "          - seeds: ${value}",
        tag     => 'seedhost',
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
