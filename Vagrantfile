# Vagrantfile to create master and slave nodes
Vagrant.configure("2") do |config|

    # Path to a custom ssh_config file to use for configuring the SSH connections.
    config.ssh.insert_key = false

    # Configure VM parameters
    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 2
    end

    # Require YAML module
    require 'yaml'

    # Read YAML file with box details
    default_vars = YAML.load_file('variables/default_var.yml')

    # Configure master node
    config.vm.define "master" do |master|
        # name of host
        master.vm.hostname = "master"
        # OS
        master.vm.box = "ubuntu/xenial64"
        # network
        master.vm.network "private_network", ip: default_vars["master_ip"]
        # forward to port for access from localhost
        master.vm.network "forwarded_port", guest: default_vars["hello_port"], host: default_vars["hello_port"]
        master.vm.network "forwarded_port", guest: default_vars["app_port"], host: default_vars["app_port"]

        # pip configuration
        master.vm.provision "shell",inline: <<-SHELL
                export DEBIAN_FRONTEND=noninteractive
                apt-get update
                apt-get install -y python-pip

        SHELL

        # provision through ansible
        master.vm.provision "ansible" do |ansible|
                ansible.verbose = "v"
                ansible.playbook = "playbook_master.yml"
                ansible.extra_vars = {
                    node_ip: default_vars["master_ip"],
                    ansible_python_interpreter:"/usr/bin/python" }
        end
    end

    # number of nodes
    N = 1

    # create node instances
    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            # name of host
            node.vm.hostname = "node-#{i}"
            # OS
            node.vm.box = "ubuntu/xenial64"
            # network
            node.vm.network "private_network", ip: default_vars["nodes_ip"]+"#{i + 10}"

            # pip configuration
            node.vm.provision "shell",inline: <<-SHELL
                export DEBIAN_FRONTEND=noninteractive
                apt-get update
                apt-get install -y python-pip
            SHELL

            # provision through ansible
            node.vm.provision "ansible" do |ansible|
                ansible.verbose = "v"
                ansible.playbook = "playbook_nodes.yml"
                ansible.extra_vars = {
                    node_ip: default_vars["nodes_ip"]+"#{i + 10}",
                    ansible_python_interpreter: "/usr/bin/python"
                }
            end
        end
    end

end
