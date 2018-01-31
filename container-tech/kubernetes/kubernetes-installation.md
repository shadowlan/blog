# How to install kubernetes
This guide is based on [official installation guide](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/)

## Install kubernetes

### Uninstall docker if any version conflict

```bash
#rpm -qa docker*
docker-ce-17.06.1.ce-1.el7.centos.x86_64
#yum -y remove docker-ce
```

### Install Docker
```bash
yum -y install docker
systemctl enable docker.service
systemctl start docker
```
[official docker installation guide](https://docs.docker.com/engine/installation/)
Recommanded docker version for k8s is 1.12, but v1.11, v1.13 and 17.03 are known to work as well

### Install kubernetes

* Configure yum repo
```bash
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```

* Install kubelet kubeadm kubectl
```bash
setenforce 0
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet
```
Disabling SELinux by running setenforce 0 is required to allow containers to access the host filesystem  
It will install latest k8s by default, you can specify version like `yum install -y kubelet-1.9.0-0.x86_64 kubeadm-1.9.0-0.x86_64 kubectl-1.9.0-0.x86_64` to install required version.

* Use kubeadm to Create a Cluster
```bash
kubeadm init --pod-network-cidr=192.168.0.0/16
```

You may get an error like "[ERROR Swap]: running with swap on is not supported. Please disable swap", please follow below steps to rerun `kubeadm init`
```
swapoff -a
kubeadm reset
kubeadm init --pod-network-cidr=192.168.0.0/16
```
`--pod-network-cidr=192.168.0.0/16` is for Network Policy to work correctly.  
Make a record of the kubeadm join command that kubeadm init outputs. You will need this in a moment. here the output is `kubeadm join --token 01bdd0.5c219432b1400e87 9.42.25.22:6443 --discovery-token-ca-cert-hash sha256:faadf2607d3312ccbc39759ff49aacc85ec0b366ef97c8a70e906fbdb3f87a51`

* Configure kubectl
  * non-root user
  ```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  ```
  * root user
  ```
  export KUBECONFIG=/etc/kubernetes/admin.conf
  ```


## Install a pod network
You **MUST** install a pod network add-on so that your pods can communicate with each other. Here we choose 'calico' as pod network solution.

```
kubectl apply -f https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
```
Once a pod network has been installed, you can confirm that it is working by checking that the kube-dns pod is Running in the output of kubectl get pods --all-namespaces. And once the kube-dns pod is up and running, you can continue by joining your nodes.

## Master Isolation
By default, your cluster will not schedule pods on the master for security reasons. If you want to be able to schedule pods on the master, e.g. for a single-machine Kubernetes cluster for development, run:
```
kubectl taint nodes --all node-role.kubernetes.io/master-
```

## Join new nodes
SSH to the node machine, and run the command that was output by "kubeadm init", here is 
```
swapoff -a
kubeadm join --token 01bdd0.5c219432b1400e87 ${master_ip}:6443 --discovery-token-ca-cert-hash sha256:faadf2607d3312ccbc39759ff49aacc85ec0b366ef97c8a70e906fbdb3f87a51
```

* If you see an error like "[preflight] Some fatal errors occurred: /proc/sys/net/bridge/bridge-nf-call-iptables contents are not set to 1", please run below command and rerun.
```
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```
Another temporary way to fix the issue:
```
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/bridge/bridge-nf-call-ip6tables
```
* If you see an issue like "there is no JWS signed token in the cluster-info ConfigMap", the root cause is the token is expired. you can regenerate the token from master server:
```
kubeadm token create
```

check the new node on master node with `kubectl get nodes`

## Kubernetes Dashboard
Run below command to deploy dashboard
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
```

You can refer to [official guide](https://github.com/kubernetes/dashboard#kubernetes-dashboard) to learn the detail of dashboard deployment.  
* Access dashboard in master node
  run `kubectl proxy`, then open  "http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/" on master server.
* Access the dashboard outside of master node
  Please refer to [Accessing-Dashboard](https://github.com/kubernetes/dashboard/wiki/Accessing-Dashboard---1.7.X-and-above)

# Tips

* Centos base repository
You can use Centos base repository for redhat 7. please visit [here](http://wiki.docking.org/index.php/CentOS_7_Base.repo) and copy the repository content to '/etc/yum.repos.d/CentOS-Base.repo', then replace the "$releasever" to "7" with below command:
```
sed -i 's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
```

if you meet a GPG key issue like "GPG key retrieval failed: [Errno 14] curl#37 - "Couldn't open file /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7"", please download the key file:
```
wget https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7 -P /etc/pki/rpm-gpg/
```
