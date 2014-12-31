# -*- mode: ruby -*-
# vi: set ft=ruby :

# require './vagrant'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Server roles includes: app, web, db
boxes = [
  { 
    name: 'ranun-dev', 
    roles: ['app'], 
    ip: '192.168.13.2', 
    vbox_config: [
      { '--memory' => '1024' }
    ],
    forwarded_ports: [
      { 8003 => 8003 },
      { 3000 => 3000 }
    ],
    synced_folders: [
      { '../ranunculus' => '/home/vagrant/app' },
      { '../design' => '/home/vagrant/design' }
    ],
    commands: [

    ]
  }
]

Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # box setting for all vm
  config.vm.box = 'trusty64'
  config.vm.box_url = 'https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/1/providers/virtualbox.box'

  # ssh config
  # config.ssh.pty = true
  config.ssh.forward_agent = true

  # vagrant-omnibus
  if Vagrant.has_plugin?('vagrant-omnibus')
    config.omnibus.chef_version = '11.16.0'
  end
  
  boxes.each do |opts|
    config.vm.define opts[:name], :priviledge => false do |config|
      # set hostname
      config.vm.hostname = opts[:name]

      # network config
      config.vm.network :private_network, ip: opts[:ip]

      # forwarding ports
      opts[:forwarded_ports].each do |port|
        port.each do |guest, host|
          config.vm.network :forwarded_port, guest: guest, host: host
        end
      end if opts[:forwarded_ports]

      # Synced folders
      opts[:synced_folders].each do |folder|
        folder.each do |folder1, folder2|
          if Vagrant::Util::Platform.windows?
            config.vm.synced_folder folder1, folder2
          else
            config.vm.synced_folder folder1, folder2, type: "nfs", mount_options: ['rw', 'vers=3', 'tcp', 'fsc']
          end
        end
      end if opts[:synced_folders]

      # VirtualBox customizations
      unless opts[:vbox_config].nil?
        config.vm.provider :virtualbox do |vb|
          # naming for vm box
          vb.name = "vagrant_#{opts[:name]}"

          # set the hw config
          opts[:vbox_config].each do |hash|
            hash.each do |key, value|
              vb.customize ['modifyvm', :id, key, value]
            end
          end
        end
      end

      # server notify
      config.vm.provision :shell, inline: "echo 'Server: #{opts[:name]} - IP: #{opts[:ip]}'"

      # custom commands
      opts[:commands].each do |cmd|
        config.vm.provision :shell, inline: cmd
      end if opts[:commands]

      # Configure the box with Chef
      config.vm.provision :chef_solo do |chef|
        chef.custom_config_path = "Vagrantfile.chef"
        
        # Chef config
        chef.environment = 'development'
        chef.environments_path = 'environments'
        chef.roles_path = 'roles'
        chef.cookbooks_path = ['cookbooks', 'site-cookbooks']
        chef.data_bags_path = 'data_bags'

        # Add a Chef roles if specified
        opts[:roles].each do |role|
          chef.add_role(role)
        end if opts[:roles].kind_of?(Array)

        # chef.log_level = :debug
      end
    end
  end
end
