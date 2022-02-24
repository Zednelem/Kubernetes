# Kubernetes - Notes

Possibilité de faire le TP en local sur une minikube
## Historique

CNCF premier projet étant K8S
https://www.cncf.io/projects/

K8S => Cluster (Node) de container
ContainerD => concurrent
Docker monte des containers c'est différent de K8S qui

## Liens utiles:

https://www.golinuxcloud.com/kubectl-label-node/

https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/
https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-token/
https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/
https://minikube.sigs.k8s.io/docs/start/

Tip: Installer curl sur une VM alpine:
```sh
apk --no-cache add curl
```

## Intro
Objet de gestion de K8S c'est un pod


Un pod se caracterise par notament une IP
un pod peu contenir 1/2 container
une application 1..x pod

dans un pod on se partage la stack TCP/IP
un container est assimilé a une fonction (sur chaque port du pod)

on associe un volume à un Pod
mais c'est un container qui monte le volume

## Yaml et K8S

avec YML on peut déclarer l'architecture de notre système

types K8S:
Pod
Deployment (est un Deployement parmis d'autres types de deployements)
Service : service réseau, permet de gérer les mécaniques de routages du client vers le serveur

cli: cubectl
- config: fichier de config contenant user et url
- url: de la connexion au master du node
- user: par certificat ou token, en tant que dev ou ops

2 types de nodes dans les clusters:
- master: 
Peut gérer la couche cluster de l'OS
Expose l'API Server
kubectl passe par l'APIServer
S'appelle aussi controle plane
Role master
- worker: 
Machine qui ont uniquement le container runtime
Reçoit du master les commandes dans un réseau privé
synchronisation via HeartBeat
Role NONE ou compute

lors d'un split brain ie problème resau private

## les solution K8s

Tanzu via VMWare

sur la machine master
```shell
sudo yum install -y yum-utils
sudo yum-config-manager  --add-repo   https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker centos
```

ensuite

```
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-port={6443,2379,2380,10248,10250,10251,10252}/tcp
firewall-cmd --permanent --add-port={179,5473,443,6443}/tcp
firewall-cmd --reload

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

yum install -y kubelet-1.20.1 kubeadm-1.20.1 kubectl-1.20.1  --disableexcludes=kubernetes

sudo systemctl enable --now kubelet

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
modprobe br_netfilter

swapoff -a
sed -e '/swap/s/^/#/g' -i /etc/fstab

kubeadm config images pull


kubeadm init    --apiserver-advertise-address=`ifconfig | grep 192.168.98. | awk  '{ print $2 }'`  --pod-network-cidr=192.168.0.0/24

mkdir /home/centos/.kube
cp -i /etc/kubernetes/admin.conf /home/centos/.kube/config
chown -R centos:centos /home/centos/.kube
```


su - centos
kubectl get nodes



tp sur machine 1 install docker
install master
install calico

sur machine 2
install docker
install 


kubectl get pods -n kube-system



## configuration

sur node  master
kubectl config get-config


## les pods
démarrer les premiers pods sur le clusters

outils vscode de formatage et autocompletion pour kubernetes

