# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = 'debian/contrib-jessie64'
    config.vm.box_check_update = false

    # Provision. Please update "args" to your needs.
    # First argument (toor) stands for the password for mysql and phpmyadmin
    # Second argument (yes) addresses VirtualBox SendFile fix (check bootstrap.sh)
    config.vm.provision :shell, path: 'bootstrap.sh', args: "toor yes"

    config.vm.network 'private_network', ip: '192.168.30.10'
    config.vm.synced_folder './www', '/var/www', :mount_options => ['dmode=777', 'fmode=666']
    
    config.vm.provider 'virtualbox' do |vb|
        vb.gui = false # Don't boot with headless mode

        vb.customize ['modifyvm', :id, '--memory',               '768']
        vb.customize ['modifyvm', :id, '--cpuexecutioncap',      '95']
        vb.customize ['modifyvm', :id, '--natdnshostresolver1',  'on']
        vb.customize ['modifyvm', :id, '--natdnsproxy1',         'on']
    end
    
    config.ssh.insert_key = false
    config.ssh.keep_alive = true
    config.ssh.forward_agent = true
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end