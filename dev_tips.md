# TODO

* https://github.com/kubernetes/examples/tree/master/staging/https-nginx
* https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
* https://www.digitalocean.com/community/tutorials/how-to-install-software-on-kubernetes-clusters-with-the-helm-package-manager
    * https://helm.sh/

# K8S BEARER TOKEN example

```shell
kubectl get sa kubernetes-dashboard -n kube-system -o json | jq -rC '.secrets'
kubectl get secret kubernetes-dashboard-token-hvjww -n kube-system -o json | jq -rC '.data.token'
```

```shell
kubectl create serviceaccount jenkins
kubectl get serviceaccounts jenkins -o yaml
kubectl get secret jenkins-token-1yvwg -o yaml
```

# update haproxy


```
kubectl get svc appsvc1 -o json | jq -jC '.spec.ports[0].nodePort'
kubectl get svc appsvc1 -o json | jq -jC '.spec.ports[0].targetPort'

{
  "appsvc1": [
    {
      "nodePort": "80",
      "targetPort": "30608"
    },
    {
      "nodePort": "443",
      "targetPort": "30609"
    }
  ]
}



kubectl get nodes -o json | jq -j '.items[0].status.addresses[0].address'
kubectl get nodes -o json | jq -j '.items[0].metadata.name'

{
  "workers": [
    {
      "ip": "10.132.0.16",
      "name": "k8s-test-worker-002"
    },
    {
      "ip": "10.132.0.15",
      "name": "k8s-test-worker-001"
    }
  ]
}



sudo apt-get install -y python3-setuptools python3-pip python3-virtualenv ipython3
#sudo apt-get install -y python-setuptools python-pip python-virtualenv ipython
#sudo pip install kubernetes



k8s_ports="kubectl get svc appsvc1 -o json"
k8s_ips="kubectl get nodes -o json"

import subprocess,json

stdout_json = json.loads(subprocess.getoutput(k8s_ports))
print (stdout_json['spec']['ports'][0]['nodePort'])
print (stdout_json['spec']['ports'][0]['targetPort'])

stdout_json = json.loads(subprocess.getoutput(k8s_ips))
print (stdout_json['items'][0]['status']['addresses'][0]['address'])
print (stdout_json['items'][0]['metadata']['name'])
```

new_array = []
new_array.append({
  "nodePort": stdout_json['spec']['ports'][0]['nodePort'],
  "targetPort": stdout_json['spec']['ports'][0]['targetPort']
  })

new_dict = {"appsvc1": new_array}



# Ingress

* https://kubernetes.github.io/ingress-nginx/
* image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.19.0


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
mkdir -p /data/k8s
echo 'Hello from Kubernetes storage' > /data/k8s/index.html
exit
```

## option 3

```shell
tmux new-session -d -s "minikube" \
    minikube mount $(pwd):/data/k8s

tmux kill-session -t minikube
```

# k8s volumes

`--runtime-config=storage.k8s.io/v1=true` ??

* examples: https://github.com/kubernetes/examples/tree/master/staging/volumes


# glusterfs

* general vars

```shell
S_FOLDER=/data/k8
C_FOLDER=/data/k8_hook
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
# echo "192.168.32.10    gserver" | sudo tee -a /etc/hosts
mkdir -p $C_FOLDER
sudo mount -t glusterfs $GSERVER:/$GNAME $C_FOLDER
for i in `seq -w 1 100`; do cp -rp /var/log/kern.log $C_FOLDER/copy-test-$i; done
```

links: https://docs.openshift.com/container-platform/3.9/install_config/storage_examples/gluster_example.html






# gluster

```shell
C_FOLDER=/data/k8_hook
GNAME=gfs
GSERVER=gserver
mkdir -p $C_FOLDER
sudo mount -t glusterfs $GSERVER:/$GNAME $C_FOLDER
ls /data/k8_hook
```

# k8s

* Create

```shell
kubectl create deploy nginx --image=nginx
kubectl expose deploy nginx --port 80 --target-port 80 --type NodePort --name=mynginx
watch kubectl get services
# curl http://192.168.32.12:nginx_port
```

* Apply

```shell
kubectl apply -f pv-glusterfs/ep-glusterfs.yaml
kubectl apply -f pv-glusterfs/pv-glusterfs.yaml
kubectl apply -f pv-glusterfs/pvc-glusterfs.yaml
kubectl apply -f pv-glusterfs/nginx-deployment-pvc_glusterfs.yaml
kubectl apply -f output/nginx-service_LoadBalancer.yaml
```

* Delete

```shell
kubectl delete ep glusterfs-ep && kubectl delete svc glusterfs-ep
kubectl delete pv gluster-pv
kubectl delete pvc gluster-pvc
kubectl delete deploy nginx
kubectl delete svc mynginx
```

* View

```shell
kubectl get deploy,ep,pv,pvc
kubectl get svc
kubectl get nodes
```





# links

* StorageClass: https://kubernetes.io/docs/concepts/storage/storage-classes/
