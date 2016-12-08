#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive


# ------------------------------------------
# DEBCONF Config for MySQL and PHPMyAdmin
# ------------------------------------------

# Set root's password for mysql to 'toor'
echo "mysql-server mysql-server/root_password password $1" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $1" | debconf-set-selections

# PHPMyAdmin default config and mysql password
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $1" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $1" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $1" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections


# ------------------------------------------
# Install Packages.
# ------------------------------------------

sudo apt-get -y update

# Mysql, Nginx, PHP (and extensions)
sudo apt-get -y install mysql-server mysql-client nginx php5-fpm
sudo apt-get -y install php5-mysql php5-curl php5-gd php5-intl php5-mcrypt php5-sqlite php5-xmlrpc

# Latest Ruby
sudo apt-get -y install zlib1g-dev build-essential ruby ruby2.1-dev

# Github Pages (includes jekyll)
sudo gem update --system
sudo gem install github-pages
sudo gem install jekyll-paginate

# NodeJS
sudo apt-get -y install nodejs

# PHPMyAdmin
sudo apt-get -q -y install phpmyadmin


# ------------------------------------------
# Configure the default Nginx site
# ------------------------------------------

sudo rm /etc/nginx/sites-available/default
sudo touch /etc/nginx/sites-available/default

sudo cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80 default_server;

    root /var/www/html;
    server_name _;

    access_log /var/log/nginx/default.access.log;
    error_log /var/log/nginx/default.error.log;

    include /etc/nginx/include.d/all-common;
    include /etc/nginx/include.d/phpmyadmin;
}
EOF


# ------------------------------------------
# This should be included in all sites
# ------------------------------------------

sudo mkdir -p /etc/nginx/include.d
sudo touch /etc/nginx/include.d/all-common

sudo cat > /etc/nginx/include.d/all-common <<'EOF'
index index.html index.php;

location / {
    try_files $uri $uri/ /index.php?q=$uri&$args;
}

location ~ /\.ht { deny all; }
location = /favicon.ico { log_not_found off; access_log off; }

location ~ \.php$ {
    try_files $uri = 404;
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    include fastcgi.conf;
}
EOF


# ------------------------------------------
# PHPMyAdmin configuration.
# ------------------------------------------

sudo touch /etc/nginx/include.d/phpmyadmin
sudo cat > /etc/nginx/include.d/phpmyadmin <<'EOF'
location /phpmyadmin {
    root /usr/share/;
    index index.php index.html index.htm;
    location ~ ^/phpmyadmin/(.+\.php)$ {
        root /usr/share/;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include /etc/nginx/fastcgi.conf;
    }

    location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt)) {
        root /usr/share/;
    }
}

location /phpMyAdmin { rewrite ^/* /phpmyadmin last; }
EOF


# ------------------------------------------
# Create WWW dir and give permissions
# ------------------------------------------

sudo mkdir -p /var/www
sudo mkdir -p /var/www/html

sudo adduser vagrant www-data
sudo chown vagrant:www-data -R /var/www
sudo chmod 0755 -R /var/www
sudo chmod g+s -R /var/www


# ------------------------------------------
# Create an example PHP file.
# ------------------------------------------

touch /var/www/html/index.php
cat > /var/www/html/index.php <<'EOF'
<?php if(isset($_GET['phpinfo'])){ die(phpinfo()); } ?>
<h1>Welcome to your server.</h1>
<a href='?phpinfo=true'>Check your PHP config.</a>
EOF


# ------------------------------------------
# Configure PHP-FPM to use local socket.
# ------------------------------------------

sudo cp /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.bak
sudo sed -ie 's/listen = 127.0.0.1:9000/listen = \/var\/run\/php5-fpm.sock/g' /etc/php5/fpm/pool.d/www.conf
sudo sed -ie 's/;listen.owner = www-data/listen.owner = www-data/g' /etc/php5/fpm/pool.d/www.conf
sudo sed -ie 's/;listen.group = www-data/listen.group = www-data/g' /etc/php5/fpm/pool.d/www.conf
sudo sed -ie 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php5/fpm/pool.d/www.conf


# ------------------------------------------
# Virtualbox & Vagrant bug related to sendFile.
# https://github.com/mitchellh/vagrant/issues/351#issuecomment-1339640
# ------------------------------------------

if [ "$2" = "yes" ] ; then
    sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
    sudo sed -ie 's/sendfile on;/sendfile off;/g' /etc/nginx/nginx.conf
fi


# ------------------------------------------
# Restart services
# ------------------------------------------

sudo service php5-fpm restart
sudo service nginx restart