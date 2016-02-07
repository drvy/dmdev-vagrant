# LEMP + Jekyll Vagrant Machine

## Introduction
A Vagrant VM machine with a LEMP (Nginx, PHP, MySQL) stack, Jekyll and NodeJS. 
Uses the 32 bits version of the Ubuntu Precise (12.04). Automates the setup of 
the Nginx, PHP (fpm), MySQL and PHPMyAdmin packages, as well as the 
github-pages package (which includes Jekyll). Its a custom machine I use in my 
projects.

## Requirements
* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com)
* [Cygwin](https://www.cygwin.com/) or any other ssh-capable terminal shell for 
the `vagrant ssh` command

## What is inside.
* Ubuntu 12.04 x32
* MySQL
* Nginx
* php5-fpm
* phpmyadmin
* Ruby 2.1
* github-pages
* Jekyll
* NodeJS

## Building the machine.
    host $ git clone https://github.com/drvy/dmdev-vagrant.git
    host $ cd dmdev-vagrant
    host $ vagrant up --provision
    
Once build, enter the machine with:

    host $ vagrant ssh
    
You can check if everything went well by opening `http://localhost` on your 
host machine.

## Shared (sync) folder
There is a shared folder that points directly to the root directory of the 
Nginx site. That is:

    host: dmdev-vagrant/wwww
    guest: /var/www/

## Database
The default MySQL user is `root`. The default password for `root` is `toor`.

Same goes for PHPMyAdmin. Default user: `root`. Default password: `toor`

__* Notice:__ As this is pretended to be a development machine, MySQL 
installation is NOT secured.

## Ports
The config forwards port `80` of both the guest and the host machine. This 
allows you to access your website by using only `http://localhost` or 
`127.0.0.1` instead of `http://localhost:8080` or `127.0.0.1:8080`. If you need 
to change this behavior just change the forwarded port to 8080 or something 
else inside the `Vagrantfile` file.

For __Jekyll__, the forwarded port is outside of the 'dangerous' zone so it 
defaults to `4000`. So, if you want to access a Jekyll server serving in the 
guest machine, just access `http://localhost:4000` on your host machine. 
Please read below on how to properly start a Jekyll server.


## Serving (and testing) with Jekyll.
There are some problems forwarding the connections between the Jekyll server 
and the guest/host. Also, you need to enable force polling so Jekyll can 
correctly watch and update the site on the go. If you want to serve a Jekyll 
site with auto-rebuild, you should use this command:

    jekyll serve --force_polling --host=0.0.0.0

If everything builds well, you should be able to access your Jekyll site on 
your host machine by accessing `http://localhost:4000`


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