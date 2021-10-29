# CKAD Tips and Tricks

[Home](index.md)

There are a many of these tips. I am highlighting few here which helped me get the grip on Kubernetes. 

## 0 - Practice, Practice and Practice

## 1 - Use Linux and Learn Vim Editor
Use Linux and Learn the basics of Vim. Exit, save, copy, paste etc. 
For practice in Linux use `vimtutor`. My favourite vim *must remember* things are,
command | description
--- | ---
:q! | exit without save
:wq | save and exit
v | select texts
d | cut/delete
p | paste
y | copy
A | append at the end of the line
dw | delete a word
x | delete single char
dd | delete line
. | repeat last command |

> Understand the vim philosophy. Vim is an editor. This is to edit the texts. Use motion commands to make it fast.

Vim Editor CheatSheet [https://vim.rtorr.com/]](https://vim.rtorr.com/)

## 2 - use Minikube
CKAD does not require cluster level activities. So minikube in a local machine is more than enough to practice. For minikube installation please visit [https://minikube.sigs.k8s.io/docs/start/](https://minikube.sigs.k8s.io/docs/start/)

## 3 - Use Katacoda
This will help you get used to the sluggy experience of Linux console in browser. So that in exam where the console is loaded the browser has similar experience. [https://katacoda.com/](https://katacoda.com/)

## 4 - Use kubectl alias
Use `alias k=kubectl` for faster typing 

```bash
$ alias k=kubectl
```

## 5 - Learn from Kubectl cheatsheet
Kubectl Cheatsheet is a great to way to have a quick view on the few aspects of Kubectl. This is the CLI which would be used in the exam. [Kubectl CheatSheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## 6 - Use short names for Kubernetes objects

| short | long |
|----|---|
po | pods
deploy | deployment
pv | persistentvolumes
pvc | persistentvolumeclaims
no | nodes
ns | namespaces
svc | services
cm | configmaps

Also there are few other in cli like

```bash
-n # for namespace
-w # for --wait
...
```

## 7 - Use dry-run

```bash
$ kubectl run web2 --image=nginx --dry-run=client -oyaml > pod.yaml
```
## 8 - Delete with no-grace

```bash
$ kubectl delete po web --grace-period=0 --force=true
```

## 9 - Bookmark difficult parts
Bookmark in the local browser.

## 10 - kubectl apply/create/delete

```bash
$ kubectl apply -f pod.yaml
```

```bash
$ kubectl delete -f pod.yaml
```

## 11 - Yaml does not like 'tab'
No TAB

## 12 - Cluster context switch

```bash
$ kubectl config 
```