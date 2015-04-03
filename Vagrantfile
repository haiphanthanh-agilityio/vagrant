# -*- mode: ruby -*-
# vi: set ft=ruby :

# require './vagrant'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Server roles includes: app, web, db
boxes = [
  { 
    name: 'mayflower-dev', 
    default: true,
    autostart: true, 
    ip: '192.168.23.2', 
    vbox_config: [
      { 'memory' => '1024' },
      { 'cpus' => '2' }
    ],
    forwarded_ports: [
      { 3000 => 3000 }
    ],
    synced_folders: [
      { '../payrollhero' => '/home/vagrant/app' }
    ],
    commands: [

    ],
    hosts: [
      'payrollhero.dev',
      'login.payrollhero.dev',
      'www.payrollhero.dev',
      'test.payrollhero.dev',
      'assets.payrollhero.dev',
      'manage.payrollhero.dev',
      'demo.payrollhero.dev'
    ]
  },
  { 
    name: 'mayflower-auth-dev', 
    default: true,
    autostart: true, 
    ip: '192.168.23.3', 
    vbox_config: [
      { 'memory' => '1024' }
    ],
    forwarded_ports: [
      { 3000 => 3030 }
    ],
    synced_folders: [
      { '../auth' => '/home/vagrant/app' }
    ],
    commands: [

    ],
    hosts: [
      'auth.payrollhero.dev'
    ]
  }
]

# Vagrant.require_plugin "vagrant-hostsupdater"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # box setting for all vm
  config.vm.box = 'trusty64'
  config.vm.box_url = 'https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/1/providers/virtualbox.box'

  # ssh config
  # config.ssh.pty = true
  config.ssh.forward_agent = true
  config.ssh.insert_key = false

  boxes.each do |opts|
    config.vm.define opts[:name], primary: opts[:default], autostart: opts[:autostart], :priviledge => true do |config|
      # set hostname
      config.vm.hostname = opts[:name]

      # Host resolver
      if opts[:hosts].kind_of?(Array)
        config.hostsupdater.remove_on_suspend = true
        config.hostsupdater.aliases = opts[:hosts]
      end

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
            config.vm.synced_folder folder1, folder2, type: :nfs
          end
        end
      end if opts[:synced_folders]

      # VirtualBox customizations
      unless opts[:vbox_config].nil?
        config.vm.provider :virtualbox do |vb|
          # naming for vm box
          vb.name = "vagrant_#{opts[:name]}"

          # DNS forward
          vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

          # set the hw config
          opts[:vbox_config].each do |hash|
            hash.each do |key, value|
              key = "--#{key}" unless key =~ /^--/
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

    end
  end
end
