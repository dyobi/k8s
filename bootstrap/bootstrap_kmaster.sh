#!/bin/bash

CYAN='\033[0;36m'
NC='\033[0m'

# Initialize k8s
echo -e "${CYAN}[Task 10] Initialize k8s cluster${NC}"
sudo sh -c 'kubeadm init --apiserver-advertise-address=172.16.16.100 --pod-network-cidr=192.168.0.0/16 >>/root/kubeinit.log 2>/dev/null'

# Copy kube admin config
echo -e "${CYAN}[Task 11] Copy kube admin config to both root and vagrant user${NC}"
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
sudo mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
sudo chown root:root /root/.kube/config
sudo cp -i /etc/kubernetes/admin.conf /vagrant/token/kube_config

# Install calico network
echo -e "${CYAN}[Task 12] Install calico network${NC}"
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml >/dev/null 2>&1
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml >/dev/null 2>&1

# Generate new token to join work node
echo -e "${CYAN}[Task 13] Generate and save cluster join command to /vagrant/token/cluster_tkn.sh${NC}"
sudo sh -c 'kubeadm token create --print-join-command > /vagrant/token/cluster_tkn.sh'
