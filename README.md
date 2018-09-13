# Simple Kubernetes deployment

This is a quick example of how to deploy a nginx service into a Kubernetes cluster.

## 1. Run Kubernetes via Minikube

* Install Minikube: https://kubernetes.io/docs/setup/minikube/

> Minikube settings:
> Global: `cat ~/.minikube/config/config.json`
> , Local: `cat ~/.minikube/machines/minikube/config.json`
> , Command: `minikube config [set|get] --help`

### 1.1. Run on Minikube driver VirtualBox

* Install VirtualBox + VirtualBox VM VirtualBox Extension Pack: https://www.virtualbox.org/wiki/Downloads
* Set default driver: `minikube config set vm-driver virtualbox`
* Start k9s cluster: `minikube start`
* Continue to *3. Run Kubernetes deployment*
* See results: `curl $(minikube service mynginx --url)`

### 1.2. Run on Minikube driver KVM2

* Install KVM2: https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#kvm2-driver
* Set default driver: `minikube config set vm-driver kvm2`
* Start k9s cluster: `minikube start`
* Continue to *3. Run Kubernetes deployment*
* See results: `curl $(minikube service mynginx --url)`

### 1.3. Stop & delete Minikube

```shell
minikube stop
minikube delete
```

## 2. Setup volumes

* Types: https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes

### 2.1. Local volume

(from: https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)

* Setup MiniKube environment

```shell
minikube start
minikube mount $(pwd)/pv-pvc-local:/tmp/k8s
```

* Apply Kubernetes configurations

```shell
kubectl apply -f pv-pvc-local/pvc-local.yaml
kubectl apply -f pv-pvc-local/pv-local.yaml
kubectl apply -f pv-pvc-local/nginx-deployment-pvc_local.yaml
kubectl apply -f output/nginx-service_LoadBalancer.yaml
curl $(minikube service mynginx --url)
```

### 2.2. GlusterFS volume

### 2.3. Google Compute Engine (GCE) Persistent Disk volume

## 3. Run Kubernetes deployment

### 3.1. Manually

* Create

```shell
kubectl run nginx --image=nginx --replicas=1 --port=80
kubectl expose deployment nginx --type=LoadBalancer --name=mynginx
```

* View

```shell
kubectl describe service mynginx
```

* Delete

```shell
kubectl delete service mynginx
kubectl delete deployment nginx
```

## 3.2. Via docker compose + kompose

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
