# == Class: role::cartaro
#
# Stand-alone Cartaro server
#
class role::cartaro {

  include profile::base
  include profile::postgis
  include profile::php
  include profile::apache
  include profile::cartaro
}
