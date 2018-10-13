Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/xenial64"

    config.vm.provider "virtualbox" do |vb|
        vb.cpus = 2
        vb.memory = "2048"
    end

    config.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository ppa:openjdk-r/ppa
        sudo add-apt-repository ppa:george-edison55/cmake-3.x
        
        sudo apt-get update

        sudo apt-get install -y openjdk-8-jdk build-essential cmake
        sudo update-ca-certificates -f
    SHELL
end
