#!/bin/bash

CYAN='\033[0;36m'
NC='\033[0m'

# Copy master's admin config
echo -e "${CYAN}[Task 10] Copy master's admin config to worker node${NC}"
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/token/kube_config /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
sudo mkdir -p /root/.kube
sudo cp -i /vagrant/token/kube_config /root/.kube/config
sudo chown root:root /root/.kube/config

# Join worker nodes to the cluster
echo -e "${CYAN}[Task 11] Join worker node to the cluster${NC}"
sudo bash /vagrant/token/cluster_tkn.sh >/dev/null 2>&1
