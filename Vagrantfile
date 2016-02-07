# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/precise32'
  config.vm.hostname = 'dmdev'

  config.vm.box_check_update = false

  config.vm.network 'forwarded_port', guest: 80,    host: 80 # Nginx
  config.vm.network 'forwarded_port', guest: 4000,  host: 4000 # Jekyll
  config.vm.network 'forwarded_port', guest: 3306,  host: 33306

  config.vm.synced_folder './www', '/var/www', nfs: true

  config.vm.provider 'virtualbox' do |v|
    v.gui = false # Don't boot with headless mode

    v.customize ['modifyvm', :id, '--memory',               '512']
    v.customize ['modifyvm', :id, '--cpuexecutioncap',      '95']
    v.customize ['modifyvm', :id, '--natdnshostresolver1',  'on']
    v.customize ['modifyvm', :id, '--natdnsproxy1',         'on']
  end

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.ssh.forward_agent = true

  # Run provision.sh
  config.vm.provision :shell, path: 'bootstrap.sh'
end