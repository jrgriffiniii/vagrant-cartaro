# == Class: profile::postgis
#
# POSTGIS profile
#
class profile::postgis {

  class { 'postgresql::globals':

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

  $script_path = "/usr/pgsql-${::postgresql::globals::globals_version}/share/contrib/postgis-${::postgresql::globals::globals_postgis_version}"
  
  # Work-around (please see MODULES-1635)
  $libdir_path = "/usr/pgsql-${::postgresql::globals::globals_version}/lib"

  Exec {

    path => ['/usr/bin', '/bin', ],
  }
  
  class { 'postgresql::server::postgis': } ->
  postgresql::server::database { 'template_postgis':
    
    istemplate => true,
    template => 'template1',
  } ->
  exec { 'createlang plpgsql template_postgis':

    user => 'postgres',
    unless => 'createlang -l template_postgis | grep -q plpgsql',
    require => Postgresql::Server::Database['template_postgis'],
  } ->

  # Work-around (please see MODULES-1635)
  #
  exec { "cat ${script_path}/postgis.sql | sed s'#\$libdir#\/usr\/pgsql-${::postgresql::globals::globals_version}\/lib#' | psql -d template_postgis -f -":
  # exec { "psql -q -d template_postgis -f ${script_path}/postgis.sql":
    user => 'postgres',
    unless => 'echo "\dt" | psql -d template_postgis | grep -q geometry_columns',
    } ->
    
  exec { "psql -q -d template_postgis -f ${script_path}/spatial_ref_sys.sql":
    user => 'postgres',
    unless => 'test $(psql -At -d template_postgis -c "select count(*) from spatial_ref_sys") -ne 0',
  } ->

  postgresql::server::role { 'cartaro':
    
    password_hash => postgresql_password('cartaro', 'secret')
  } ->
    
  postgresql::server::db { 'cartaro':
    
    user     => 'cartaro',
    password => postgresql_password('cartaro', 'secret'),
    template => 'template_postgis'
  }
}
