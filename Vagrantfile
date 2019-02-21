# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']

MACHINES = {
  :otuslinux => {
        :box_name => "centos/7",
        :ip_addr => '192.168.11.101',
	:disks => {
		:sata1 => {
			:dfile => home + '/OTUS/VirtualBox_VMs/sata1.vdi',
			:size => 1024,
			:port => 1
		},
		:sata2 => {
                        :dfile => home + '/OTUS/VirtualBox_VMs/sata2.vdi',
                        :size => 250, # Megabytes
			:port => 2
		},
                :sata3 => {
                        :dfile => home + '/OTUS/VirtualBox_VMs/sata3.vdi',
                        :size => 250,
                        :port => 3
                },
                :sata4 => {
                        :dfile => home + '/OTUS/VirtualBox_VMs/sata4.vdi',
                        :size => 250, # Megabytes
                        :port => 4
                },
                # Добавлено 5 дисков по 200Мб.
                :sata25 => {
                        :dfile => home + '/OTUS/VirtualBox_VMs/sata5.vdi',
                        :size => 200, # Megabytes
                        :port => 5
                },
                :sata26 => {
                        :dfile => home + '/OTUS/VirtualBox_VMs/sata6.vdi',
                        :size => 200, # Megabytes
                        :port => 6
                },
                :sata27 => {
                        :dfile => home + '/OTUS/VirtualBox_VMs/sata7.vdi',
                        :size => 200, # Megabytes
                        :port => 7
                },
                :sata28 => {
                        :dfile => home + '/OTUS/VirtualBox_VMs/sata8.vdi',
                        :size => 200, # Megabytes
                        :port => 8
                },
                :sata29 => {
                        :dfile => home + '/OTUS/VirtualBox_VMs/sata9.vdi',
                        :size => 200, # Megabytes
                        :port => 9
                },
               
	}

		
  },
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s

          #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
            	  vb.customize ["modifyvm", :id, "--memory", "1024"]
                  needsController = false
		  boxconfig[:disks].each do |dname, dconf|
			  unless File.exist?(dconf[:dfile])
				vb.customize ['createmedium', '--filename', dconf[:dfile], '--format', 'VDI', '--variant', 'Fixed', '--size', dconf[:size]]
                                needsController =  true
                          end

		  end
                  if needsController == true
                     vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
                     boxconfig[:disks].each do |dname, dconf|
                         vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                     end
                  end
          end
      

      config.vm.provision "file", source: "./scripts/init_md.sh", destination: "init_md.sh" 

 	  box.vm.provision "shell", inline: <<-SHELL
	      mkdir -p ~root/.ssh
              cp ~vagrant/.ssh/auth* ~root/.ssh
	      yum install -y mdadm smartmontools hdparm gdisk
              yum install -y gcc bc bison cpp flex gpm kernel-headers path perl wget lzma mpfr glibc vim
              sudo -i bash ~vagrant/init_md.sh
  	  SHELL

          #box.vm.provision "shell", path: "scripts/init_md.sh"

      end
  end
end

