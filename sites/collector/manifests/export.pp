#
# Export seed ip address
#
define collector::export (
  $value = '',
  $timestamp = generate('/bin/date', '+%Y%d%m%H%M%S'),
  ){

  @@concat::fragment { "seedhost${timestamp}":
    content => "          - seeds: ${value}\n",
    tag     => 'seedhost',
  }
}
