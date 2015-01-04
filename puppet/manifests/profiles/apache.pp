# == Class: profile::apache
#
# Apache profile
#
class profile::apache {

  class { '::apache':
    
    docroot       => '/var/www/cartaro-7.x-1.5',
  }

  include apache::mod::php        # include mod php

  firewall { '001 allow http and https access for Apache HTTP Server':
    
    port   => [80, 443],
    proto  => tcp,
    action => accept
  }

#  class { 'php': }
#  php::ini { 'php':
    
#    value   => ['date.timezone = "Europe/Amsterdam"'],
#    target  => 'php.ini',
#    service => '::apache',
#  }

#  apache::vhost { 'cartaro.localdomain':
    
#    port    => '443',
#    docroot       => '/var/www/cartaro',
#    ssl     => true,
#  }
}
