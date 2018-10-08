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
        wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
        sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main"
        sudo apt-get update
        sudo apt-get install -y openjdk-8-jdk clang-6.0
        sudo update-ca-certificates -f

        update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100
        update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-6.0 1000
        update-alternatives --install /usr/bin/clang++ clang /usr/bin/clang-3.8 100
        update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100
        update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 1000
        update-alternatives --config clang
        update-alternatives --config clang++
    SHELL
end
