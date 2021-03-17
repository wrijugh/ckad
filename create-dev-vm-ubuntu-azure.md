# Creating Economical Ubuntu VM for Development in Azure

We can create an Ubuntu VM in Azure and install all the tools needed for it. While doing so we can also consider how we spend less on this one.

There are many ways by which you can create a VM. We will have a script to do so. While we have the script which will work on Azure CLI has some consideration.

- Use manages disk. This will immensely reduce the cost of VM as compared to the Standard or Premium SSD which is the default. So if we don't mention that we will use unmanaged disks then Azure CLI will use managed disk with Premium SSD.
  > While doing so you don't need to pre-create a storage. If we consider to create a storage and mention that it will be Locally Redundant then it would first find if there is any such storage matching the criteria. If nothing is found then it would create the storage before creating the VM.
- Network: Virtual Network, Subnet, Public IP all will be created automatically by Azure CLI before the VM creation.
- NSG can also be attached to ensure that for Linux SSH port 22 is open.
- Enable Auto-Shutdown. We must explicitly apply this setting post VM creation it is provisioned.

## Script to Create VM

### Login to Azure CLI

If you run the below command then it would prompt you to login in browser. Sometimes it opens the browser and you just provide your credentials. If Multi-Factor is enabled then it would also kick in.

> If you try the below from a headless Linux box then it would give an URL with a key. You open a browser in any machine and use that URL, enter the key and provide azure login - CLI will allow you to work from now onwards.

```bash
az login 
```

> If you are using [Cloud Shell](https://shell.azure.com) then you are already logged in. Just to ensure that you are in right subscription if you have access to more than one subscription, you may run the below command.

```sh
# to see the list of subscription you have access to 
az account list

# to check the current subscription run
az account show

# to set the current subdcription 
az account set --subscription {{name/guid}}
```

### Creating Resource Group and VM

Now you can create the Azure Resource Group and the VM from the below Script by either copying each line one by one and pasting it to Azure CLi or by creating a `.sh` file to run as a whole.

```sh
n="vm-ubuntu-wg"
g="rg-ubuntu"
l=eastus

admin="ubuntu-admin"
passwd="TwelveCharecter123!@#"
vmname="ubuntu-dev"
size="Standard_DS2_v2"

echo "--------------- Creating Resource Group"
az group create -n $g -l eastus

echo "--------------- Creating Ubuntu Virtual Machine"
# Cost saving use --use-unmanaged-disk --storage-sku "Standard_LRS"
az vm create -n $vmname -g $g --admin-username $admin --admin-password $passwd --authentication-type password --os-disk-size-gb 200 --image ubuntults --size $size

echo "--------------- Setting Auto-shutdown (UTC)"
az vm auto-shutdown -n $vmname -g $g --time 1730
```

In above we have created Resource Group, Virtual Machine, and Auto-Shut down. Boom!!!

Now it is time to connect the VM or ssh into it through the Public Ip. To get the public ip you can use the below command,

```sh
az vm show -d -n $n -g $g --query "publicIps" -o tsv
```

Then using the Public IP ssh into the VM to install the tools

```sh
# 192.168.1.1 Sample Public IP
$ ssh ubuntu-admin@192.168.1.1
```

## Installing Tools

We will be installing the below tools,

- Git
- Docker ce
- Kubectl
- Azure CLI
- Dotnet Core
- Go
- Python (already there)
- Node.js

We have a file. You can make a file like `script.sh` and save to your home directory. Then follow few steps,

```sh
# make it executable 
$ chmod +x script.sh

# then run the file - sit back and relax
$ ./script.sh
```

### Sample installation shell script

```sh
#/bin/bash

echo "-------------- Task 1: Installing Git"
sudo apt-get update
sudo apt-get install -y git

echo "-------------- Task 2: Installing Kubectl"
sudo snap install kubectl --classic
#sudo apt-get update
#curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
#echo "$(<kubectl.sha256) kubectl" | sha256sum --check
#sudo install -y -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
#mkdir -p ~/.local/bin/kubectl
#mv ./kubectl ~/.local/bin/kubectl

echo "-------------- Task 3: Installing Azure CLI"

sudo apt-get update
yes Y | sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

echo "-------------- Task 4: Dot Net Core 5"
wget https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update; \
          sudo apt-get install -y apt-transport-https && \
          sudo apt-get update && \
          sudo apt-get install -y dotnet-sdk-5.0

echo "-------------- Task 5: Python"
echo "Python3 is by default available in Ubuntu 20.04"
echo "To Open Python use $ python3"

echo "-------------- Task 6: Installing Node.js "
yes Y | sudo apt-get install nodejs

echo "-------------- Task 7: Go Lang"
yes Y | sudo apt install golang-go
yes Y | sudo apt install gccgo-go

echo "-------------- Task 8: Installing Docker CLI"

sudo apt-get update
yes Y | sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -l https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo apt-get update
# yes Y | sudo apt-get install docker-ce
# yes Y | sudo apt-get install docker-ce-cli
# yes Y | sudo apt-get install containerd.io
sudo apt-get install -y docker.io

# yes Y | sudo apt-get install docker-ce
#sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Task 9 : Minikube
echo "-------------- Task 9: Installing and stating Minikube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start
```

## Connecting Remote Ubuntu from Visual Studio Code

<iframe width="560" height="315" src="https://www.youtube.com/embed/UkiPauLyzg4" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

[https://youtu.be/UkiPauLyzg4](https://youtu.be/UkiPauLyzg4)

This should ideally setup your dev environment. Enjoy.