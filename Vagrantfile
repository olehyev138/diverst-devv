# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Use Ubuntu 14.04 Trusty Tahr 64-bit as our operating system
  config.vm.box = "ubuntu/trusty64"

  # Configurate the virtual machine to use 2GB of RAM
  config.vm.provider :virtualbox do |v|
    host = RbConfig::CONFIG["host_os"]

    if host =~ /darwin/ # OS X
      # sysctl returns bytes, convert to MB
      v.memory = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 2
      v.cpus = `sysctl -n hw.ncpu`.to_i
    elsif host =~ /linux/ # Linux
      # meminfo returns kilobytes, convert to MB
      v.memory = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 2
      v.cpus = `nproc`.to_i
    end
  end

  # Forward the Rails server default port to the host
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 35729, host: 35729

  # Use Chef Solo to provision the VM
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]
    chef.add_recipe "apt"
    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::user"
    chef.add_recipe "rbenv::vagrant"
    chef.add_recipe "vim"
    chef.add_recipe "mysql::server"
    chef.add_recipe "mysql::client"
    chef.add_recipe "elasticsearch"
    chef.add_recipe "java"
    chef.add_recipe "redisio"
    chef.add_recipe "imagemagick"
    chef.add_recipe "phantomjs"

    # Install Ruby 2.3.0 and Bundler
    # Set an empty root password for MySQL to make things simple1
    chef.json = {
      rbenv: {
        user_installs: [{
          user: 'vagrant',
          rubies: ["2.3.0"],
          global: "2.3.0",
          gems: {
            "2.3.0" => [
              { name: "bundler" }
            ]
          }
        }]
      },
      mysql: {
        server_root_password: ''
      },
      elasticsearch: {
        version: '2.2.0'
      },
      java: {
        install_flavor: 'oracle',
        jdk_version: '7',
        oracle: {
          accept_oracle_download_terms: true
        }
      },
      nodejs: {
        npm_packages: [{
          name: 'bower'
        }]
      }
   }
  end

  # Use rsync for shared folders (much faster)
  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  config.ssh.forward_agent = true
end