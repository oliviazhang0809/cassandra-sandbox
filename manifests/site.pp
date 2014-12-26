#
# site.pp - defines defaults for vagrant provisioning
#
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

stage { 'last':
 require => Stage['main'],
 }
 
hiera_include('classes')

# remove warning about deprecated allow_virtual
if versioncmp($::puppetversion,'3.6.1') >= 0 {
  $allow_virtual_packages = hiera('allow_virtual_packages',false)
  Package {
    allow_virtual => $allow_virtual_packages,
  }
}
