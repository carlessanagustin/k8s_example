# Simple Kubernetes  example

This is a group examples to deploy a Nginx service in a Kubernetes (k8s) environment. For this purpose we'll use these tools: Make, Docker Engine, Docker Compose, Vagrant, Minikube, KVM2, VirtualBox, Kubectl, Kubeadm, GlusterFS, Ansible.

**Part I: Deploy Nginx**

* Usage of kubctl commands to manually deploy an Nginx container in a K8s cluster.
* Using Kompose to convert a Nginx docker-compose.yml file into k8s yaml files.

**Part II: Deploy Nginx with storage**

* Local volume
* GlusterFS volume
* Google Compute Engine (GCE) Persistent Disk volume

*More k8s Types of Volumes: https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes*

----

## PART I: : Deploy Nginx

### 1. Manually (CLI)

* Create

```shell
kubectl run nginx --image=nginx --replicas=1 --port=80
kubectl expose deployment nginx --type=LoadBalancer --name=mynginx
```

* View

```shell
watch kubectl describe service mynginx
```

* Delete

```shell
kubectl delete service mynginx
kubectl delete deployment nginx
```

## 2. Via docker compose + kompose

* Requirements:
    * Install kompose: http://kompose.io/

* From `docker-compose.yml`

```yaml
version: '3'

services:
  nginx:
    image: nginx:1.15
    ports:
      - "80:80"
    restart: unless-stopped
```

* Run: `kompose convert -f docker-compose.yml`
* Output:

```
WARN Restart policy 'unless-stopped' in service nginx is not supported, convert it to 'always'
INFO Kubernetes file "nginx-service.yaml" created
INFO Kubernetes file "nginx-deployment.yaml" created
$ tree
.
├── nginx-deployment.yaml
└── nginx-service.yaml
```

* Change @`nginx-service.yaml`:

`name: nginx` >> `name: mynginx`

* Add @`nginx-service.yaml`:

```yaml
spec:
  type: LoadBalancer
```

* Apply YAML configurations:

```shell
kubectl apply --filename nginx-deployment.yaml
kubectl apply --filename nginx-service.yaml
kubectl describe service mynginx
```
----

## PART II: Deploy Nginx with storage

### 1. Deploy Nginx with a local volume
(best for development environments)

#### 1.1. Run Kubernetes on Minikube

* Install Minikube: https://kubernetes.io/docs/setup/minikube/

> Minikube settings:
> Global: `cat ~/.minikube/config/config.json`
> , Local: `cat ~/.minikube/machines/minikube/config.json`
> , Command: `minikube config [set|get] --help`

#### 1.2. Setup Minikube driver

* VirtualBox

1. Install VirtualBox + VirtualBox VM VirtualBox Extension Pack: https://www.virtualbox.org/wiki/Downloads
2. Set default driver: `minikube config set vm-driver virtualbox`

* KVM2

1. Install KVM2: https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#kvm2-driver
2. Set default driver: `minikube config set vm-driver kvm2`

#### 1.3. Deploy test environment: Local volume

(from: https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)

* Create environment: Start MiniKube, mount folder & apply k8s scripts

```shell
make localv_up
```

* View results

```shell
make localv_results
```

> Output: This is a HOSTPATH test

* Destroy environment

```shell
make localv_down
```

* Official documentation
    * https://kubernetes.io/docs/setup/minikube/#persistent-volumes
    * https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/


### 2. Deploy Nginx with a GlusterFS volume

* Create environment: Start Vagrant instances, provision K8s, provision GlusterFS, deploy Nginx pod

```shell
make glusterv_up
```

* View results

```shell
vagrant ssh k8sMaster
    $ curl http://192.168.32.12:$(kubectl get svc mynginx -o json | jq -j '.spec.ports[0].nodePort')
```

> Output: This is a GLUSTERFS test

* Destroy environment

```shell
make glusterv_down
```

* Official documentation
    * https://docs.gluster.org/en/v3/CLI-Reference/cli-main/
    * https://docs.openshift.com/container-platform/3.9/install_config/storage_examples/gluster_example.html

### 3. Deploy Nginx with a Google Compute Engine (GCE) Persistent Disk volume

TODO
