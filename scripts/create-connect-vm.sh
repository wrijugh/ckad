#!/bin/bash

location='eastus'
rgroup='rg-vm'
vmname='vm-ubuntu-temp'
username='wriju'
filename='setup-dev-linux.sh'

az vm create -g $rgroup -n $vmname --image UbuntuLTS --size Standard_DS2 --authentication-type=password --admin-username $username --admin-password=P@ssw0rd1234

# To get the public IP
pip=$(az vm show -d -g rg-vm -n vm-ubuntu-temp --query 'publicIps' -o tsv)
echo $pip

scp $filename $username@$pip:/home

ssh $pip@$username 

cd ~
chmod +x $filename
