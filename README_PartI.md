# Simple Kubernetes  example (cont.)

[back](./README.md)

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
or
watch kubectl get service mynginx -o wide
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

[back](./README.md)
