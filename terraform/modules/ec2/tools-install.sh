#!/bin/bash
set -e

exec > /var/log/user-data.log 2>&1

# Update packages
apt update -y

# Base tools
apt install -y curl wget unzip gnupg lsb-release ca-certificates software-properties-common apt-transport-https snapd

# Java 21 (required for modern Jenkins)
apt install -y openjdk-21-jdk openjdk-21-jre

# Docker
apt install -y docker.io
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# Jenkins Repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | gpg --dearmor > /usr/share/keyrings/jenkins.gpg

echo "deb [signed-by=/usr/share/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list

apt update -y
apt install -y jenkins

# Add Jenkins to Docker group
usermod -aG docker jenkins

# Start Jenkins
systemctl enable jenkins
systemctl start jenkins

# AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -o awscliv2.zip
./aws/install

# kubectl latest stable
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin/

# Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com noble main" > /etc/apt/sources.list.d/hashicorp.list

apt update -y
apt install -y terraform

# Trivy
curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor > /usr/share/keyrings/trivy.gpg

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb noble main" > /etc/apt/sources.list.d/trivy.list

apt update -y
apt install -y trivy

# Helm
snap install helm --classic

# SonarQube Container
docker run -d --restart unless-stopped --name sonar -p 9000:9000 sonarqube:lts-community