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


# glusterfs

* general vars

```shell
S_FOLDER=/tmp/gfs
C_FOLDER=/tmp/gfs_hook
GNAME=gfs
GSERVER=gserver
```

* single node server

```shell
sed -i "s|^127.0.0.1.*|& $GSERVER|m" /etc/hosts
mkdir -p $S_FOLDER
gluster volume create $GNAME $GSERVER:$S_FOLDER force
gluster volume start $GNAME
gluster volume info
gluster volume status $GNAME detail
```

* multiple node server

```shell
gluster peer probe <new_server>
gluster peer status
...
gluster volume create $GNAME replica <num> $GSERVER1:$S_FOLDER $GSERVER2:$S_FOLDER force
```

* in client

```shell
echo "192.168.39.1    gserver" | sudo tee -a /etc/hosts
mkdir -p $C_FOLDER
sudo mount -t glusterfs $GSERVER:/$GNAME $C_FOLDER
for i in `seq -w 1 100`; do cp -rp /var/log/kern.log $C_FOLDER/copy-test-$i; done
```

links: https://docs.openshift.com/container-platform/3.9/install_config/storage_examples/gluster_example.html

# links

* StorageClass: https://kubernetes.io/docs/concepts/storage/storage-classes/
