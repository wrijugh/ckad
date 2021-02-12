#/bin/bash
echo
echo "========================"
echo "Task 1: Installing Git"
echo "========================"
sudo apt-get update
sudo apt-get install git

echo
echo "==========================="
echo "Task 2: Installing Kubectl"
echo "==========================="

sudo apt-get update
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
mkdir -p ~/.local/bin/kubectl
mv ./kubectl ~/.local/bin/kubectl

echo
echo "============================="
echo "Task 3: Installing Azure CLI"
echo "============================="

sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

echo
echo "=============================="
echo "Task 4: Installing Docker CLI"
echo "=============================="

sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -l https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo 
echo "=============================="
echo "Task 5: Dot Net Core 5"
echo "=============================="
wget https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update; \
	  sudo apt-get install -y apt-transport-https && \
	  sudo apt-get update && \
	  sudo apt-get install -y dotnet-sdk-5.0

echo
echo "=============================="
echo "Task 6: Python"
echo "=============================="
echo "Python3 is by default available in Ubuntu 20.04" 
echo "To Open Python use $ python3" 

echo
echo "=============================="
echo "Task 7: Installing Node.js "
echo "=============================="
sudo apt-get install nodejs

echo
echo "=============================="
echo "Task 8: Go Lang"
echo "=============================="
echo
sudo apt install golang-go
sudo apt install gccgo-go
