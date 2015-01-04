
# Deprecated; Work-around for Vagrant
import 'profiles/*.pp'
import 'roles/*.pp'

node /^db\d*/ {
  
  include role::db
}

node /^www\d*/ {
  
  include role::www
}

node /^cartaro\d*/ {
  
  include role::cartaro
}

node default { }
