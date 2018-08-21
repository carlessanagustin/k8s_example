# Simple Kubernetes deployment

This is a quick example of how to deploy a nginx service into a Kubernetes cluster.

## Option 1: manually

* Create

```shell
kubectl run nginx --image=nginx --replicas=1 --port=80
kubectl expose deployment nginx --type=LoadBalancer --name=mynginx
kubectl describe service mynginx
```

* Delete

```shell
kubectl delete service mynginx
kubectl delete deployment nginx
```

## Option 2: via docker compose + kompose

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
```

```
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