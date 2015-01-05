# == Class: profile::base
#
# Base profile
#
class profile::base {

  package { "unzip":

    ensure => "installed"
  }
}
