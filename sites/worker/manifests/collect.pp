class worker::collect {
  @@file { '/etc/facter/facts.d/master_hostname.txt':
        content =>    $::fqdn,
        tag     => 'master_hostname',
    }

    File <<| tag == 'master_hostname' |>> {}
}