# == Class: profile::cartaro
#
# Cartaro profile
#
class profile::cartaro {

  # Drush Module does not permit one to pass environment variable
  $pg_pass = 'secret'

  exec { "download_cartaro":

    command => "/usr/bin/wget http://ftp.drupal.org/files/projects/cartaro-7.x-1.5-core.tar.gz -O /tmp/cartaro.tar.gz",
    unless => "/usr/bin/stat /tmp/cartaro.tar.gz"
    } ->
  exec { "decompress_cartaro":

    command => "/bin/tar -xvf /tmp/cartaro.tar.gz -C /var/www",
    unless => "/usr/bin/stat /var/www/cartaro-7.x-1.5/sites"
  } ->

  class { '::drush': } ->
  exec { 'drush_env' :
         command => "/bin/bash -c \"export PGPASS=${pg_pass}\"",
  } ->
  drush::exec { "deploy_cartaro": #     unless => '/usr/bin/stat /var/www/cartaro-7.x-1.5/sites/default/settings.php'

    command => "si cartaro --account-mail=admin@cartaro.localdomain --account-pass=secret --db-url=pgsql://cartaro:secret@localhost:5432/cartaro --site-mail=admin@cartaro.localdomain --site-name=Cartaro",
    root_directory => '/var/www/cartaro-7.x-1.5',
    options => [ '--yes' ]
  }

  # drush -r /var/www/cartaro si cartaro --account-mail=admin@cartaro.localdomain --account-pass=secret --db-url=pgsql://cartaro:secret@localhost:5432/cartaro --site-mail=admin@cartaro.localdomain --site-name=Cartaro -y
}
