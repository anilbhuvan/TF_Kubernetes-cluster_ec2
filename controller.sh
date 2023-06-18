#! /bin/bash
# changing hostname
sudo hostnamectl hostname k8s-controller

# Forwarded IPv4 and enabled iptables to see bridged traffic
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# configured sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

touch /home/ubuntu/"configured-10%"

# installing go lang
sudo apt-get update -y
sudo snap install go --classic

# install docker
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# configuring docker for non-root user
sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker
sudo swapoff -a

# Enabling docked
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

rm -rf /home/ubuntu/"configured-10%"
touch /home/ubuntu/"configured-35%"


# Installing CRI-dockerd
cd /home/ubuntu
git clone https://github.com/Mirantis/cri-dockerd.git
cat <<EOF > script.sh
#! /bin/bash
cd cri-dockerd
mkdir bin
go build -o bin/cri-dockerd
mkdir -p /usr/local/bin
install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
cp -a packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket
EOF
cd /home/ubuntu
sudo bash script.sh

# Installing kubeadm, kubelet and kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl restart kubelet
sudo systemctl daemon-reload
rm -rf /home/ubuntu/"configured-35%"
touch /home/ubuntu/"configured-75%"

# initilizing cluster
sudo su ubuntu
cd /home/ubuntu 
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --cri-socket=unix:///var/run/cri-dockerd.sock

# kubernetes configuration after creating cluster
sudo mkdir /home/ubuntu/.kube
sudo chown ubuntu:ubuntu /home/ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config

# configuring calico network-plugin
cd /home/ubuntu
sudo curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/calico.yaml -O
kubectl apply -f /home/ubuntu/calico.yaml

# printing join command to a file.
sudo kubeadm token create --print-join-command | tee /home/ubuntu/join_command.txt
sed -i 's|kubeadm|sudo kubeadm|' /home/ubuntu/join_command.txt
sed -i 's|--token|--cri-socket=unix:///var/run/cri-dockerd.sock --token|' /home/ubuntu/join_command.txt

# creating readme file
cat <<EOF > READ_ME.txt
Configuration completed 100%
- HostName changed
- Forwarded IPv4 and enabled iptables to see bridged traffic
- configured sysctl params required by setup, params persist across reboots
- Installed Go lang
- Installed Docker
- Enabled Docker
- Installed CRI-Dockerd
- Installed kubeadm, kubelet and kubectl
- Initilized Kubernetes Cluster
- Configured Kubernetes Cluster
- Downloaded Calico network plugin
- configured Calico network plugin
- Printed join command and saved at /home/ubuntu/join_command.txt

To add worker nodes to this cluster, SSH into the worker node and run join_command.txt as a command
Two EC2 Instances were already created and configured in your AWS, Use them as worker nodes.
.
.
.
EOF

rm -rf /home/ubuntu/"configured-75%"
touch /home/ubuntu/"configured-100%"
