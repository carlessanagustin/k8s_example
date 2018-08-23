# Simple Kubernetes deployment

This is a quick example of how to deploy a nginx service into a Kubernetes cluster.

## 1. Run Kubernetes via Minikube

* Install Minikube: https://kubernetes.io/docs/setup/minikube/

### 1.1. Run on Minikube driver VirtualBox

* Install VirtualBox + VirtualBox VM VirtualBox Extension Pack: https://www.virtualbox.org/wiki/Downloads
* Set default driver: `minikube config set vm-driver virtualbox`

> More settings: `~/.minikube/machines/minikube/config.json`

* Start k9s cluster: `minikube start`
* Continue with `2. Run Kubernetes deployment`
* See results: `curl $(minikube service mynginx --url)`

### 1.2. Run on Minikube driver KVM2

* Install KVM2: https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#kvm2-driver
* Set default driver: `minikube config set vm-driver kvm2`

> More settings: `~/.minikube/machines/minikube/config.json`

* Start k9s cluster: `minikube start`
* Continue with `2. Run Kubernetes deployment`
* See results: `curl $(minikube service mynginx --url)`

### 1.3. Stop & delete Minikube

```shell
minikube stop
minikube delete
```

## 2. Run Kubernetes deployment

### 2.1. Manually

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

## 2.2. Via docker compose + kompose

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
