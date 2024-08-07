Vagrant.configure("2") do |config|

  # General VM settings
  def config_vm(vm)
    vm.vm.box = "ubuntu/focal64"
    vm.vm.provision "shell", path: "bootstrap/bootstrap.sh"
  end

  # K8s master node
  config.vm.define "kmaster" do |kmaster|
    config_vm(kmaster)
    kmaster.vm.hostname = "kmaster.example.com"
    kmaster.vm.network "private_network", ip: "172.16.16.100"
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "kmaster"
      v.memory = 2560
      v.cpus = 2
    end
    kmaster.vm.provision "shell", path: "bootstrap/bootstrap_kmaster.sh"
  end

  NodeCount = 2

  # K8s worker nodes
  (1..NodeCount).each do |i|
    config.vm.define "kworker#{i}" do |workernode|
      config_vm(workernode)
      workernode.vm.hostname = "kworker#{i}.example.com"
      workernode.vm.network "private_network", ip: "172.16.16.10#{i}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "kworker#{i}"
        v.memory = 1024
        v.cpus = 1
      end
      workernode.vm.provision "shell", path: "bootstrap/bootstrap_kworker.sh"
    end
  end

end
