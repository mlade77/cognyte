Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.box_url = "centos/7"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    end

config.vm.define "vm1" do |vm1|
vm1.vm.hostname = 'vm1'
vm1.vm.network "forwarded_port", guest: 80, host: 10001
end

config.vm.define "vm2" do |vm2|
vm2.vm.hostname = 'vm2'
vm2.vm.network "forwarded_port", guest: 80, host: 10002
end

config.vm.provision :ansible do |ansible|
  ansible.playbook = "provisioning/playbook.yml"
  ansible.groups = {
    "group1" => ["machine[1:2"]
}
end

end