# == Class: role::db
#
# Relational database management system web server profile
#
class role::db {

  include profile::postgis
  include profile::base
}
