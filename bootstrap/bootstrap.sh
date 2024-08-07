#!/bin/bash

CYAN='\033[0;36m'
NC='\033[0m'

# Update hosts file
echo -e "${CYAN}[Task 01] Update /etc/hosts file${NC}"
sudo bash -c 'cat >>/etc/hosts<<EOF
172.16.16.100 kmaster.example.com kmaster
172.16.16.101 kworker1.example.com kworker1
172.16.16.102 kworker2.example.com kworker2
EOF'

# Stop and disable swap
echo -e "${CYAN}[Task 02] Disable and turn off SWAP${NC}"
sudo sed -i '/swap/s/^/#/' /etc/fstab
sudo swapoff -a

# Stop and disable firewall
echo -e "${CYAN}[Task 03] Stop and disable firewall${NC}"
sudo systemctl disable ufw >/dev/null 2>&1
sudo systemctl stop ufw

# Install containerd and configure
echo -e "${CYAN}[Task 04] Install containerd and configure${NC}"
wget https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz >/dev/null 2>&1
sudo tar Cxzvf /usr/local containerd-1.6.14-linux-amd64.tar.gz >/dev/null 2>&1
wget https://github.com/opencontainers/runc/releases/download/v1.1.3/runc.amd64 >/dev/null 2>&1
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz >/dev/null 2>&1
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz >/dev/null 2>&1
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo curl -L https://raw.githubusercontent.com/containerd/containerd/main/containerd.service -o /etc/systemd/system/containerd.service >/dev/null 2>&1
rm -rf cni-plugins-linux-amd64-v1.1.1.tgz containerd-1.6.14-linux-amd64.tar.gz runc.amd64

# Daemon reload and enable containerd
echo -e "${CYAN}[Task 05] Daemon reload and enable containerd${NC}"
sudo systemctl daemon-reload
sudo systemctl enable --now containerd >/dev/null 2>&1

# Add sysctl settings
echo -e "${CYAN}[Task 06] Add sysctl settings${NC}"
sudo bash -c 'cat >>/etc/sysctl.d/k8s.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF'
sudo sysctl --system >/dev/null 2>&1

# Enable overlay network and bridge netfilter
echo -e "${CYAN}[Task 07] Enable overlay network and bridge netfilter${NC}"
sudo bash -c 'cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF' >/dev/null 2>&1
sudo modprobe overlay
sudo modprobe br_netfilter
sudo sysctl --system >/dev/null 2>&1

# Install k8s
echo -e "${CYAN}[Task 08] Install k8s${NC}"
sudo apt update >/dev/null 2>&1
sudo apt install -y apt-transport-https ca-certificates curl gpg >/dev/null 2>&1
sudo mkdir -p /etc/apt/keyrings/
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg >/dev/null 2>&1
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null 2>&1
sudo apt update >/dev/null 2>&1
sudo apt install -y kubelet kubeadm kubectl >/dev/null 2>&1
sudo apt-mark hold kubelet kubeadm kubectl >/dev/null 2>&1

# Start and enable k8s
echo -e "${CYAN}[Task 09] Start and enable k8s service${NC}"
sudo systemctl enable kubelet >/dev/null 2>&1
sudo systemctl start kubelet

