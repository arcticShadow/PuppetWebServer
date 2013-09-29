$mynetworks = []

# Setup Postfix
include postfix

# Setup NGINX
node default {
    class { 'nginx': }
    nginx::resource::vhost { 'www.example.com':
        ensure   => present,
        www_root => '/var/www/www.example.com',
    }
    nginx::resource::vhost { 'www.isthistherealsiteoristhisjustfantasy.com':
        ensure   => present,
        www_root => '/var/www/www.isthistherealsiteoristhisjustfantasy.com',
    }
}

# Setup MySQL (will eventually be MariaDB hopefully)
class { 'mysql::server':
    config_hash => { 'root_password' => 'welcomemat' }
}



# Setup vim
class {'vim': } # This guys module is really basic, no config file even...

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
