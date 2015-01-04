# == Class: profile::postgis
#
# POSTGIS profile
#
class profile::postgis {
  
  class { 'postgresql::globals':

    # version => '9.2',
    manage_package_repo => true,
    
    } ->
  class { 'postgresql::server':

    listen_addresses => '*',

    # ip_mask_deny_postgres_user => '0.0.0.0/32',
    # ip_mask_allow_all_users    => '0.0.0.0/0',
    # ipv4acls                   => ['hostssl all 192.168.0.0/24 cert'],
    postgres_password          => 'secret',
  }

  # PostGIS for the GeoServer database
  # include ::postgis

  # The following error is encountered for CentOS 6.4:
  # Error: psql -q -d template_postgis -f /usr/pgsql-8.4}/share/contrib/postgis-1.5/postgis.sql returned 1 instead of one of [0]

  # A proposed modification has been made using pull request 33: https://github.com/camptocamp/puppet-postgis/pull/33
  # @todo Remove this work-around

  class { 'postgresql::server::postgis': }
  ->
  postgresql::server::database { 'template_postgis':
    
    istemplate => true,
    template => 'template1',
  }

  $script_path = "/usr/pgsql-${::postgresql::globals::globals_version}/share/contrib/postgis-${::postgresql::globals::globals_postgis_version}"
  
  Exec {
    
    path => ['/usr/bin', '/bin', ],
  }
  exec { 'createlang plpgsql template_postgis':
    
    user => 'postgres',
    unless => 'createlang -l template_postgis | grep -q plpgsql',
    require => Postgresql::Server::Database['template_postgis'],
    } ->

    # cat /usr/pgsql-8.4/share/contrib/postgis-1.5/postgis.sql | sed s'/$libdir/\/usr\/pgsql-8.4\/lib/' | psql -d template_postgis -f -
    # "psql -q -d template_postgis -f ${script_path}/postgis.sql"
    # Work-around (to register this issue with the community to be addressed)
    #
  exec { "cat /usr/pgsql-8.4/share/contrib/postgis-1.5/postgis.sql | sed s'/$libdir/\/usr\/pgsql-8.4\/lib/' | psql -d template_postgis -f -":
    user => 'postgres',
    unless => 'echo "\dt" | psql -d template_postgis | grep -q geometry_columns',
    } ->
  exec { "psql -q -d template_postgis -f ${script_path}/spatial_ref_sys.sql":
    user => 'postgres',
    unless => 'test $(psql -At -d template_postgis -c "select count(*) from spatial_ref_sys") -ne 0',
  }

  postgresql::server::role { 'cartaro':
    
    password_hash => postgresql_password('cartaro', 'secret')
  }

  postgresql::server::db { 'cartaro':
    
    user     => 'cartaro',
    password => postgresql_password('cartaro', 'secret'),
    template => 'template_postgis'
  }
}
