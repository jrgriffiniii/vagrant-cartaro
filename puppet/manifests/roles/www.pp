# == Class: role::www
#
# World Wide Web (WWW) server profile
#
class role::www {

  include profile::base
  include profile::php
  include profile::apache  
  include profile::cartaro
}

