Puppet Server Setup Scripts
===========================

Making puppet scripts to setup a server with NGINX, Postfix and MariaDB.

Thus far NGINX and Postfix are running. Some more detailed config would be
required for a production server. 

KNOWN BUGS:
  + NGINX vhosts aren't given their Document Roots 


TODO:
  - Create a New Dedicated unix user (i.e. theweb) and group
  + Module https://forge.puppetlabs.com/thias/php
    - Configure Module for a single php-fpm pool using a dedicated user (theweb) and group
    + Setup fpm to listen on a socket at in /var/run/fpm/socket or similar - sockets are faster than tcp bindings (which is the default)
        Need something like this put in the vhost config file:
        location ~ \.php$ {
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $request_filename;
                fastcgi_intercept_errors on;
                fastcgi_pass unix:/var/run/php5-fpm.sock;
        }
    + Obtain configuration examples and working setup from ceres - do not change anything on ceres
    + Seup some Defaults for PHP, for drupal. 
  + Nginx (per vhost) Configure to pass any php files to the fpm socket (see the location tag in ceres for example, also php module has example)
  + Nginx - Add a default vhost that displays a simple page such as jupiter.netactive.co.nz does
  + Add phpMyAdmin Package
  + Add Nginx Vhost for phpmyadmin
  + Add a default bash profile - some nice colors and a usefull PS1 Var (git branch info would be nice, see dev's root ps1 var i think)
  + Install Package - Nagios NRPE
  + Install Package - ?? 
  + cron job to optimize mysql tables nightly 6am
  + Munin (Add to a sepearte .pp file and include it from the main init.pp)
    + install and configure for appropriate software
    + Add Nginx Vhost
