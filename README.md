# LEMP, NodeJS and Jekyll Vagrant machine.

__Notice__: This vagrant box and it's bootstrap script are obsolete. Check the new one based on Ubuntu here:
https://github.com/drvy/drvys-box

## Introduction
Basic Vagrant Setup with a bootstrap script for a LEMP (Ningx PHP7, MariaDB) stack, Jekyll, NodeJS, Ruby and Composer. Makes use of the 64 bit version of Debian Jessie box provided by Vagrant itself. Automates the setup and initial configuration of the packages.

It's a custom machine I use in my projects.

## Requirements
* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com)
* [Cygwin](https://www.cygwin.com/) or any other ssh-capable terminal shell.
* [Rsync](https://es.wikipedia.org/wiki/Rsync) if you're using a Windows host.

## What is inside.
* Debian Jessie (x64) (`debian/contrib-jessie64`)
* MariaDB (`mariadb-server mariadb-client`)
* Nginx (`nginx`)
* PHP 7 (`php7.0-fpm`)
* Ruby 2.1 (`ruby2.1-dev`)
* NodeJS (`nodejs`)
* github-pages (`github-pages bundler jekyll-paginate`)
* Jekyll (_provided with github-pages_)
* Composer (_lastest version on provision_).

__PHP Extensions__
`php7.0-cli php7.0-curl php7.0-dev php7.0-zip php7.0-gd php7.0-xml php7.0-mysql php7.0-mcrypt php7.0-mbstring php7.0-opcache`

__Other Packages__
`curl zlib1g-dev build-essential`

## Building the machine.
    host $ git clone https://github.com/drvy/dmdev-vagrant.git
    host $ cd dmdev-vagrant
    host $ vagrant up

Once build, log into the machine with:

    host $ vagrant ssh

You can check if everything went well by opening `http://192.168.30.10` on your host machine.

## Shared (sync) folder
There is a shared folder that points directly to the root directory of the  Nginx site. That is:

    host: dmdev-vagrant/wwww
    guest: /var/www/

### Rsync on Windows

Please notice that some boxes like the one used here, force the sharing method to `rsync`. RSYNC does NOT come by default in Windows environments and you need to install it by yourself before running the box for the first time.

The easiest way to install it is to install the CyGWIN platform. Go to [Cygwin.com](https://www.cygwin.com/), download and run the installer. When it prompts you for packages to install, be sure to select `rsync` and `openssh`.

Also, notice that the GIT installer for Windows although it does include some UNIX tools, does NOT provide rsync therefore you should use the CyGWIN Terminal to provision and run your Vagrant box.

## Database
The default MariaDB user is `root`. The default password for `root` is `toor`.
You can change that by changing the arguments for the provisioning inside the `Vagrantfile`.

__* Notice:__ As this is pretended to be a development machine, MariaDB installation is NOT secured.

### Access
You can access the database as normal. PHPMyAdmin is NOT available. You can use any external program for such task by providing the default params. Recommendend and tested programs: [Navicat](https://www.navicat.com/), [HeidiSQL](https://www.heidisql.com/) and [MySQL Workbench](https://www.mysql.com/products/workbench/).

A setup example for _Navicat_ would be:
![Navicat Config](https://i.imgur.com/QuVmJoQ.gif)

Vagrant is instructed not to generate a random key file, so your __Private Key__ will be inside the Vagrant folder named as `insecure_private_key`.

## Ports
- The only port fowarded is the default SSH (22), and its done automatically by Vagrant.
- GitHub-Pages or Jekyll use by default the port 4000.
- MariaDB uses the default port (3306)

## Serving (and testing) with Jekyll.
There are some problems forwarding the connections between the Jekyll server  and the guest/host. Also, you need to enable force polling so Jekyll can  correctly watch and update the site on the go. If you want to serve a Jekyll site with auto-rebuild, you should use this command:

    jekyll serve --force_polling --host=0.0.0.0

If everything builds well, you should be able to access your Jekyll site on your host machine by accessing `http://192.168.30.10:4000`

## Nginx
The default nginx virtualhost (site) is replaced with a custom one in order to be able to serve PHP files. No big changes. You can check the `bootstrap.sh` file to see what the build looks like.

The default site serves files from `/var/www/`.
The default site logs are in `/var/log/nginx/`.

### SSL.
On provision, the machine will generate a self-signed certificate to enable NGINX SSL (HTTPS). Since the key is self-signed, you will be presented with an alert on any modern browser. Just skip or replace the certificate (`/etc/nginx/conf.d/certs/dmdev.(cert/key)`) with your own.

### `sendfile off;`
Due to a known bug with Virtualbox, the `sendfile` directive is disabled by default after installation. You can change this behavior inside the `Vagrantfile`. However you may experience some annoying behavior like files not updating after a change on the host machine.

## URLs.
This are the default URLs on your host machine:

|   Service    |                                                     URL |
|:------------:|--------------------------------------------------------:|
| HTTP (Nginx) | `http://192.168.30.10` or `https://192.168.30.10`       |
| Jekyll       | `http://192.168.30.10:4000`                             |

## Virtual Machine Management (Vagrant)
These are the basic commands to manage the vagrant machine. If you want to know
more about them, just check the official Vagrant documentation.

|    Action    |                                     Command |
|:------------:|--------------------------------------------:|
| First Start  | `vagrant up --provision`                    |
| Normal Start | `vagrant up`                                |
| Suspend      | `vagrant suspend`                           |
| Resume       | `vagrant resume`                            |
| Shutdown     | `vagrant halt`                              |
| Destroy      | `vagrant destroy`                           |
| Status       | `vagrant status`                            |


## License
    The MIT License (MIT)

    Copyright (c) 2018 Dragomir Yordanov

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
