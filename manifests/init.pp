#Lets update repo's

exec { 'apt-get update':
    command => "/usr/bin/apt-get update",
    onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'"
}





#$mynetworks = []

## Setup Postfix
#include postfix

## Setup NGINX
node default {
    class { 'nginx': }
    nginx::resource::vhost { 'www.example.com':
        ensure   => present,
        www_root => '/var/www/www.example.com',
        require  => [ 
			File['/var/www/www.example.com'],
			Exec['apt-get update']
		    ],
    }

## Trying to get location stuff going    
#     $location_config_example.com = {
#         'fastcgi_split_path_info' => '^(.+\.php)(/.+)$',
#         #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
#         'include'                   => 'fastcgi_params',
#         'fastcgi_param'             => 'SCRIPT_FILENAME $request_filename',
#         'fastcgi_intercept_errors'  => 'on',
#         'fastcgi_pass'              => 'unix:/var/run/php5-fpm.sock'
#     }
#     nginx::resource::location {
#         vhost => 'www.example.com',
#         location => '~ \.php$'
#         location_cfg_prepend => $location_config_example.com,
#     }

    nginx::resource::vhost { 'www.isthistherealsiteoristhisjustfantasy.com':
        ensure   => present,
        www_root => '/var/www/www.isthistherealsiteoristhisjustfantasy.com',
        require  => File['/var/www/www.isthistherealsiteoristhisjustfantasy.com'],
    }
}

# or you can assign them to a variable and use them in the resource
$nginx_dir = [ "/var/www" ]

file { $nginx_dir:
    ensure => "directory",
    owner  => "www-data",
    group  => "www-data",
    mode   => 750,
}

$nginx_dirs = [ 
		"/var/www/www.isthistherealsiteoristhisjustfantasy.com",
                "/var/www/www.example.com"
                ]

file { $nginx_dirs:
    ensure => "directory",
    owner  => "theweb",
    group  => "theweb",
    mode   => 750,
    require => [ 
		User['webuser'],
	 	File['/var/www/']
	       ] 
}

## Setup MySQL (will eventually be MariaDB hopefully)
class { 'mysql::server':
    config_hash => { 'root_password' => 'welcomemat' },
    require =>  Exec['apt-get update'],
}



## Setup vim
class {'vim':
	require => Exec['apt-get update'], 
	 } # This guys module is really basic, no config file even...



## I started writing this one. Needs a bit of editing to get the config right
# package { 'vim':
#     ensure => present,
#     # Need to fix this to be cross-system
#     before => File['/usr/share/vim/vim73/debian.vim'],
# }
# 
# file { '/usr/share/vim/vim73/debian.vim':
#     ensure => file,
#     mode => 644,
#     source => , ## GET A VIMRC FILE FROM SOMEWHERE USEFUL
# }

## Create a web user and group
user {'webuser':
    name   => 'theweb',
    ensure => present,
    shell  => '/bin/bash',
    gid    => 'theweb',
}

group {'webusers':
    name   => 'theweb',
    ensure => present,
    before => User['webuser'],
}

## Manage php
include php::fpm::daemon
php::fpm::conf { 'www':
    listen  => '/var/run/php5-fpm.sock',
    user    => 'theweb',
    group   => 'theweb',
    # For the user to exist
    require =>  Package['nginx'],
}

## Create a socket file for fpm
file { '/var/run/php5-fpm.sock':
    ensure => present,
}
