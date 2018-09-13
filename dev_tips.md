
```shell
minikube ssh
ssh -i $(minikube ssh-key) docker@$(minikube ip)
ssh -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip)
```


`--runtime-config=storage.k8s.io/v1=true` ??


* Setup MiniKube environment

```shell
minikube start
minikube ssh
```

* Inside MiniKube instance

```shell
mkdir -p /tmp/k8s
echo 'Hello from Kubernetes storage' > /tmp/k8s/index.html
exit
```
