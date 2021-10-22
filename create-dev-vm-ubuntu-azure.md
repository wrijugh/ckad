# Creating Economical Ubuntu VM for Development in Azure

We can create an Ubuntu VM in Azure and install all the tools needed for it. While doing so we can also consider how we spend less on this one.

There are many ways by which you can create a VM. We will have a script to do so. While we have the script which will work on Azure CLI has some consideration.

- Use unmanaged disk. This will immensely reduce the cost of VM as compared to the Standard or Premium SSD which is the default. We will use `--use-unmanaged-disk` OTHERWISE Azure CLI will use managed disk with Premium SSD.
  > While doing so you don't need to pre-create a storage. If we consider to create a storage and mention that it will be Locally Redundant then it would first find if there is any such storage matching the criteria. If nothing is found then it would create the storage before creating the VM.
- Network: Virtual Network, Subnet, Public IP, NSG (for port 22), NIC all will be created automatically by Azure CLI before the VM creation.
- Enable Auto-Shutdown. We must explicitly apply this setting post VM creation it is provisioned. A big cost saving.

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
g="rg-ubuntu"
l="eastus"

admin="ubuntuadmin"
# Password: 12 letter long one caps, one small, one numeric, one special char atleast
passwd="TwelveCharecter123!@#" 
vmname="ubuntu-dev"
size="Standard_DS2_v2"

echo "--------------- Creating Resource Group"
az group create -n $g -l eastus

echo "--------------- Creating Ubuntu Virtual Machine"
# Cost saving use --use-unmanaged-disk --storage-sku "Standard_LRS"
az vm create -n $vmname -g $g --admin-username $admin --admin-password $passwd --authentication-type password --os-disk-size-gb 200 --image ubuntults --size $size --use-unmanaged-disk --storage-sku "Standard_LRS"

echo "--------------- Setting Auto-shutdown (UTC)"
az vm auto-shutdown -n $vmname -g $g --time 1730

#Public IP will be printed after this too 
az vm show -d -n $n -g $g --query "publicIps" -o tsv
```

In above we have created Resource Group, Virtual Machine, and Auto-Shut down. Boom!!!

Now it is time to connect the VM or ssh into it through the Public Ip. To get the public ip you can use the below command,

```sh
n="ubuntu-dev"
g="rg-ubuntu"

az vm show -d -n $n -g $g --query "publicIps" -o tsv
```

Then using the Public IP ssh into the VM to install the tools

```sh
# 192.168.1.1 Sample Public IP
$ ssh ubuntu-admin@192.168.1.1
```

### To start this VM daily

Try to use Sceduled Logic Apps or use the below script

```sh
n="ubuntu-dev"
g="rg-ubuntu"

az vm start -n $n -g $g
```

## To deallocate (stop and release IPs)

```sh
az vm deallocate -n $n -g $g
```

## Installing Tools

We will be installing the below tools using [snap](https://snapcraft.io/)

- Git (already there)
- Docker ce
- Kubectl
- Azure CLI
- Dotnet Core
- Go
- Python (already there)
- Node.js
- Open JDK

You can make a file like `script.sh` and save to your home directory. Then follow few steps,

```sh
# create a blank file
$ touch script.sh

# make it executable 
$ chmod +x script.sh

# then run the file - sit back and relax
$ ./script.sh
```

### Sample installation shell script

> If you have the script in your local terminal then using the Public IP you can do a secure file transfer to the newly created remote VM.
> `$ scp script.sh {adminuser}@{publicIp}:/home/{adminuser} `

*Copy the whole content to* `script.sh`

```sh
#/bin/bash

echo "-------------- Task 1: Snap Install"
sudo apt update
sudo apt install snapd

echo "-------------- Task 2: Installing Kubectl"
sudo snap install kubectl --classic

echo "-------------- Task 3: Installing Azure CLI"
# sudo snap install azure-cli --candidate 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "-------------- Task 4: Dot Net Core 5"
sudo snap install dotnet-sdk --classic
sudo snap alias dotnet-sdk.dotnet dotnet

echo "-------------- Task 5: Open JDK"
sudo snap install openjdk

echo "-------------- Task 6: Installing Node.js "
sudo snap install node --classic

echo "-------------- Task 7: Go Lang"
sudo snap install go --classic

echo "-------------- Task 8: Installing Docker CLI"
sudo snap install docker

set +e #on error continue
sudo addgroup --system docker
sudo adduser $USER docker
newgrp docker
sudo snap disable docker
sudo snap enable docker


echo "-------------- Task 9: Installing and stating Minikube"
# sudo snap install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

```

## Connecting Remote Ubuntu from Visual Studio Code

<iframe width="560" height="315" src="https://www.youtube.com/embed/UkiPauLyzg4" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

[https://youtu.be/UkiPauLyzg4](https://youtu.be/UkiPauLyzg4)

This should ideally setup your dev environment.

## Clean Up everything

Simply go to Azure Portal and delete the resource group or run the below command

```sh
az group delete -n RESOURCE_GROUP_NAME
```

## Troubleshooting

Notice in this script there are 9 Taks and the terminal will print the current tasks and its output. At any given point in time if the terminal ends due to any reason without moving further then the tools are not installed completely,

- You run the same script again
- Or type `$ exit` and this would start executing the remaining of the script.

> Most of the time error could be due to the docker group and its assignment. Then run them manually. Till I find a solid way to run the flawless script.

*Enjoy*  
Wriju @wrijugh