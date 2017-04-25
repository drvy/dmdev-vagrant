#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive


# ------------------------------------------
# DEBCONF Config for MySQL
# ------------------------------------------

# Set root's password for mysql to 'toor'
echo "mysql-server mysql-server/root_password password $1" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $1" | debconf-set-selections

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
<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='utf-8'>
    <title>dMDev Vagrant Box</title>
    <style type='text/css'>
        html, body {
            margin: 0; padding: 0; font-size: 16px; 
            color: #111; font-family: Monospace;
            text-align: center; background: #f5f5f5;
        }
        .box { max-width: 600px; margin: 5% auto 0 auto; padding: 5px; }
        h1 { font-size: 2.1em; letter-spacing: -1px; } h1 em { color: #069; }
        ul { list-style: square inside; text-align: left; } li { padding: 2px; }
        a, a:visited { color: #069; padding: 2px; text-decoration: none; border-bottom: 1px dashed #ccc;}
        a:hover, a:active { color: #111; text-decoration: none; border-bottom: 1px solid #111; }
        code { background: #fff; padding: 1px; }
        .hearth { color: #A93232; }
    </style>
</head>
<body>
    <div class='box'>
        <h1>Welcome to <em><code>dMDev Vagrant Box</code></em>!</h1>
        <ul>
            <li><a href='?phpinfo=true'>Check PHP Config</a></li>
            <li><a href='https://github.com/drvy/dmdev-vagrant' target='_blank'>Fork the project on GitHub</a></li>
            <li>
                <a href='https://www.navicat.com/' target='_blank'>Navicat</a> / 
                <a href='https://www.heidisql.com/' target='_blank'>HeidiSQL</a> / 
                <a href='https://www.mysql.com/products/workbench/' target='_blank'>MySQL Workbench</a>
            </li>
        </ul>

        <p>You can now start running and developing your projects.</p>
        <p>Read the included <code>README.md</code> for documentation.</p>
        <small>
            Version 3.0 | 
            Made with by <span class='hearth'>&#10084;</span>
            <a href='https://github.com/drvy' target='_blank'>Dragomir Yordanov</a>
        </small>
    </div>
</body>
</html>
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