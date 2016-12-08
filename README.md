# LEMP, NodeJS and Jekyll Vagrant machine.

## Introduction
A Vagrant machine with a LEMP (Nginx, PHP, MySQL) stack, Jekyll and NodeJS. Makes
use of the 64 bit version of Debian Jessie (7). Automates the setup of the 
Nginx, PHP (fpm), MySQL and PHPMyAdmin packages, as well as the github-pages 
package (which includes Jekyll).

Its a custom machine I use in my  projects.

## Requirements
* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com)
* [Cygwin](https://www.cygwin.com/) or any other ssh-capable terminal shell.
* [Rsync](https://es.wikipedia.org/wiki/Rsync) if you're using a Windows host.

## What is inside.
* Debian Jessie (x64) (`debian/contrib-jessie64`)
* MySQL
* Nginx
* php5-fpm
* PHPMyAdmin
* Ruby 2.1
* github-pages
* Jekyll
* NodeJS

## Building the machine.
    host $ git clone https://github.com/drvy/dmdev-vagrant.git
    host $ cd dmdev-vagrant
    host $ vagrant up
    
Once build, enter the machine with:

    host $ vagrant ssh
    
You can check if everything went well by opening `http://localhost` on your 
host machine.

## Shared (sync) folder
There is a shared folder that points directly to the root directory of the 
Nginx site. That is:

    host: dmdev-vagrant/wwww
    guest: /var/www/

### Rsync on Windows

Please notice that some boxes like the one used here, force the sharing method 
to `rsync`. RSYNC does NOT come by default in Windows environments and you need 
to install it by yourself before running the box for the first time.

The easiest way to install it is to install the CyGWIN platform. Go to 
[Cygwin.com](https://www.cygwin.com/), download and run the installer. When it 
prompts you for packages to install, be sure to select `rsync` and `openssh`.

Also, notice that the GIT installer for Windows although it does include some UNIX 
tools, does NOT provide rsync therefore you should use the CyGWIN Terminal to 
provision and run your Vagrant box.

## Database
The default MySQL user is `root`. The default password for `root` is `toor`.

Same goes for PHPMyAdmin. Default user: `root`. Default password: `toor`.

You can change that by changing the arguments for the provisioning inside the
`Vagrantfile`.

__* Notice:__ As this is pretended to be a development machine, MySQL 
installation is NOT secured.

## Ports
The config forwards port `80` of both the guest and the host machine. This 
allows you to access your website by using only `http://localhost` or 
`127.0.0.1` instead of `http://localhost:8080` or `127.0.0.1:8080`. If you need 
to change this behavior just change the forwarded port to 8080 or something 
else inside the `Vagrantfile` file.

For __Jekyll__, the forwarded port is outside of the 'dangerous' zone so it 
defaults to `4000`. To access a Jekyll server serving in the guest machine,
access `http://localhost:4000` on your host machine.  Please read below on how
to properly serve a Jekyll server.


## Serving (and testing) with Jekyll.
There are some problems forwarding the connections between the Jekyll server 
and the guest/host. Also, you need to enable force polling so Jekyll can 
correctly watch and update the site on the go. If you want to serve a Jekyll 
site with auto-rebuild, you should use this command:

    jekyll serve --force_polling --host=0.0.0.0

If everything builds well, you should be able to access your Jekyll site on 
your host machine by accessing `http://localhost:4000`

## Nginx
The default nginx virtualhost (site) replaced with a custom one in order to
be able to serve PHP files. No big changes. You can check the `bootstrap.sh` file
to see what the build looks like.

The default site serves files from `/var/www/html`.
The default site logs are in `/var/log/nginx/`.

### `sendfile off;`
Due to a known bug with Virtualbox, the `sendfile` directive is disabled by default
after installation. You can change this behavior inside the `Vagrantfile`. However
you may experience some annoying behavior like files not updating after a change.

## URLs.
This are the default URLs on your host machine:

|   Service    |                                         URL |
|:------------:|--------------------------------------------:|
| HTTP (Nginx) | `http://localhost` or `127.0.0.1`           |
| Jekyll       | `http://localhost:4000` or `127.0.0.1:4000` |
| PHPMyAdmin   | `http://localhost/phpmyadmin`               |


## Virtual Machine Management (Vagrant)
This are the basic commands to manage the vagrant machine. If you want to know 
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


## Licence
    The MIT License (MIT)
    
    Copyright (c) 2016 Dragomir Yordanov
    
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