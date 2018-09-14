# minikube

## option 1

```shell
minikube ssh
ssh -i $(minikube ssh-key) docker@$(minikube ip)
ssh -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip)
```

## option 2

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

## option 3

```shell
tmux new-session -d -s "minikube" \
    minikube mount $(pwd):/tmp/k8s

tmux kill-session -t minikube
```

# k8s volumes

`--runtime-config=storage.k8s.io/v1=true` ??

* examples: https://github.com/kubernetes/examples/tree/master/staging/volumes
