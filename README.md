Vagrant for Cartaro
===============

A Vagrant box for Cartaro (still under active development).

## Known Issues

* Creating the PostGIS table for the Cartaro site requires the following invocations:
  * `cat /usr/pgsql-8.4/share/contrib/postgis-1.5/postgis.sql | sed s'/$libdir/\/usr\/pgsql-8.4\/lib/' | psql -d template_postgis -f -`
  * `psql -q -d template_postgis -f ${script_path}/spatial_ref_sys.sql`
  * _This was implemented as a work-around for issues arising within the _postgis_ package installed using the _camptocamp/postgis_ module_
  * Proper handling for the failure of these tasks must be implemented
* The installation of the site with the following invocation:
  * `drush si cartaro --account-mail=admin@cartaro.localdomain --account-pass=secret --db-url=pgsql://cartaro:secret@localhost:5432/cartaro --site-mail=admin@cartaro.localdomain --site-name=Cartaro -r /var/www/cartaro-7.x-1.5`
  * Proper handling for the failure of this task (which likely requires some work-around to the exclusion of the _erikwebb/drush_ module) must, also, be implemented

