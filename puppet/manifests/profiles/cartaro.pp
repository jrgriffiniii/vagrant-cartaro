# == Class: profile::cartaro
#
# Cartaro profile
#
class profile::cartaro {

  exec { "download_cartaro":

    command => "/usr/bin/wget http://ftp.drupal.org/files/projects/cartaro-7.x-1.5-core.tar.gz -O /tmp/cartaro.tar.gz",
    } ->
  exec { "decompress_cartaro":

    command => "/bin/tar -xvf /tmp/cartaro.tar.gz -C /var/www"
    }
#  file { '/var/www/cartaro':
    
#    ensure => 'link',
#    target => '/var/www/cartaro-7.x-1.5'
#  }

  include ::drush
  drush::exec { "deploy_cartaro":

    command => "si cartaro --account-mail=admin@cartaro.localdomain --account-pass=secret --db-url=pgsql://cartaro:secret@localhost:5432/cartaro --site-mail=admin@cartaro.localdomain --site-name=Cartaro",
    root_directory => '/var/www/cartaro-7.x-1.5'
  }

  # drush -r /var/www/cartaro si cartaro --account-mail=admin@cartaro.localdomain --account-pass=secret --db-url=pgsql://cartaro:secret@localhost:5432/cartaro --site-mail=admin@cartaro.localdomain --site-name=Cartaro -y
}
