# Helm入门指南

## 概念
* Chart：一个 Helm 包，其中包含了运行一个应用所需要的工具、资源定义等，还可能包含 Kubernetes 集群中的服务定义，类似 Homebrew 中的 formula，APT 的 dpkg 或者 Yum 的 RPM 文件
* Release: 在 Kubernetes 集群上运行的 Chart 的一个实例。在同一个集群上，一个 Chart 可以安装很多次。每次安装都会创建一个新的 release。例如一个 MySQL Chart，如果想在服务器上运行两个数据库，就可以把这个 Chart 安装两次。每次安装都会生成自己的 Release，会有自己的 Release 名称。
* Repository：用于存放和共享 Chart 的仓库。

简单说来，Helm 整个系统的主要任务就是，在仓库中查找需要的 Chart，然后把 Chart 以 Release 的形式安装到 Kubernetes 之中

## 组件
* Helm Client：客户端，具有对 Repository、Chart、Release 等对象的管理能力。
* Tiller Server：负责客户端指令和 Kubernetes 集群之间的沟通，根据 Chart 定义，生成和管理各种相对应的 API Object。
* Repository：Chart 的仓库，基本上就是索引文件 + Chart 压缩包的一个存储托管。

## 安装
在有外网链接的情况下，只需要下载[helm二进制文件v2.8.0][helm-v2.8.0]，解压并拷贝helm并拷贝到`/usr/local/bin`,然后执行`helm init`即可，helm会通过读取你本地的k8s配置文件（通常是$HOME/.kube/config）来安装Tiller。更多的安装方式及选项可以参考[快速入门][quick-start]和[官方安装文档][install-helm]

### 安装客户端

任意能够链接K8S cluster环境的节点都可以配置为Helm客户端，但需要保证相应节点已经配置的正确的k8s config，通过执行
`helm init -c`跳过 Tiller 部分，仅进行客户端的安装。

* ~/.helm 中保存了对 Repository 的定义，各个 Repository 的索引的缓存，以及 Chart 压缩包的缓存。
* 如果当前用户home目录下没有.kube/config文件,执行`helm init -c`时，helm将默认和本地8080端口的k8s api通信，那么可能会出现如下错误：

`Error: Get http://localhost:8080/api/v1/namespaces/kube-system/pods?labelSelector=app%3Dhelm%2Cname%3Dtiller: dial tcp [::1]:8080: getsockopt: connection refused`

那么需要正确配置k8s config后才能使用helm客户端，参考下面的示例命令配置正确的k8s conifg:
```
kubectl config set-cluster k8s-default \
  --certificate-authority=/etc/kubernetes/pki/ca.crt \
  --embed-certs=true \
  --server=https://${K8S_API_Server_IP}:6443 \
  --kubeconfig=default.kubeconfig

kubectl config set-credentials kubernetes-admin \
  --client-certificate=/root/.kube/k8s-admin.crt \
  --client-key=/root/.kube/kubernetes-admin.key \
  --embed-certs=true \
  --kubeconfig=default.kubeconfig

kubectl config set-context default --cluster='k8s-default' --user='kubernetes-admin' --kubeconfig=default.kubeconfig

kubectl config use-context default --kubeconfig=default.kubeconfig

export  KUBECONFIG=deafult.kubeconfig
#注意如果default.kubeconfig不在当前工作目录，需要提供文件的绝对路径 
```

* 如果能够访问master节点的.kube/config文件，可以简单的将其拷贝到节点的.kube目录下并使用。通过kubeadmin安装时自动生成的admin.conf配置文件中，为kubernetes-admin用户生成的密钥对可以通过`echo $REDACTED_STRING | base64 -d > file.crt`来获得，具体可以参考[issue-521][issue-521]

* 如果不指定KUBECONFIG变量，可以通过`helm init -c --kube-context default --kubeconfig default.kubeconfig`来初始化helm客户端。

## 常用命令
* 创建chart: `helm create first_chart`
* 打包chart: `helm package $chart_path`
* 查看及搜索:
```
helm search mysql #搜索
helm inspect stable/mysql #查看
```
* 安装: `helm install stable/mysql`  
    当执行`helm install`时可以利用 --set 或者 --value 参数，来指定在helm inspect命令中看到的变量的值，完成对变量的设置
* 运行简单Helm仓库
```
helm serve --repo-path repo
```
* 添加一个helm repo
```
helm repo add bitnami-incubator https://charts.bitnami.com/incubator
```

## 参考文档和链接
* [Helm简介][cn-guide]
* [Getting Started Authoring Helm Charts][athoring-charts]

[helm-v2.8.0]: https://kubernetes-helm.storage.googleapis.com/helm-v2.8.0-linux-amd64.tar.gz
[install-helm]: https://docs.helm.sh/using_helm/#installing-helm
[quick-start]: https://github.com/kubernetes/helm/blob/master/docs/quickstart.md#Install-Helm
[cn-guide]: http://blog.fleeto.us/content/helm-jian-jie
[athoring-charts]: https://deis.com/blog/2016/getting-started-authoring-helm-charts/
[issue-521]: https://github.com/kubernetes/kubeadm/issues/521
