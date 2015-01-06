#
# set up java
#
define javaimpl::set (
  $value = '',
  ){
  exec { "set_up_${value}":
      command => "sudo alternatives --install /usr/bin/${value} ${value} /opt/jdk${javaimpl::jdk_version}/bin/${value} 1",
      unless  => "alternatives --display java | grep '1.7.0'",
  }
}
