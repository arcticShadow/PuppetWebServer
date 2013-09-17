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
