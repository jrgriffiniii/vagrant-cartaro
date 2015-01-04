# == Class: profile::php
#
# PHP profile
#
class profile::php {
  
  class { '::php':

    # version => '5.3.3'
  }

  # System dependencies for PHP extensions
  Package { ensure => "installed" }
  $system_deps = [ "php-mbstring", "php-gd", "php-xml", "php-pgsql", "php-pdo" ]

  # PHP extensions for Cartaro
  # $php_deps = [ "mbstring", "gd", "xml" ]
  
  package { $system_deps: }
  # php::module { $php_deps: }
}
