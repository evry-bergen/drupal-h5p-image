FROM drupal:8-apache


#RUN COMPOSER_MEMORY_LIMIT=-1 composer create-project drupal/recommended-project my_site_name_dir
RUN COMPOSER_MEMORY_LIMIT=-1 composer require drush/drush
RUN COMPOSER_MEMORY_LIMIT=-1 composer require 'drupal/h5p:^1.0@RC'
#RUN COMPOSER_MEMORY_LIMIT=-1 composer require drupal/console:~1.0 --prefer-dist --optimize-autoloader

#COPY bin/drush.phar /usr/local/bin/
#RUN chmod a+x /usr/local/bin/drush.phar



RUN apt-get update && apt-get install -y sqlite3

#RUN drush site-install --db-url=sqlite://ht.sqlite --account-name=admin --account-pass=admin
RUN drush site-install standard --db-url=sqlite://sites/default/files/.ht.sqlite --account-name=admin --account-pass=admin
RUN drush en h5p
RUN drush en h5peditor
RUN chown -R www-data:www-data web/sites/default/files
#COPY h5p/.ht.sqlite web/sites/default/files
RUN chmod a+rw web/sites/default/files/.ht.sqlite


#Add h5p to basic content type
COPY h5p/import import
RUN drush cim --partial --source /opt/drupal/import/ -y

#COPY h5p/h5p-8.x-1.0-rc17.tar.gz .
#RUN tar xvzf h5p-8.x-1.0-rc17.tar.gz -C web/modules

