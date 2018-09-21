from https://akomljen.com/kubernetes-nginx-ingress-controller/

* In k8sMaster

```shell
kubectl create -f app-deployment.yaml -f app-service.yaml
kubectl create namespace ingress
kubectl create -f default-backend-deployment.yaml -f default-backend-service.yaml -n=ingress
kubectl create -f nginx-ingress-controller-config-map.yaml -n=ingress
kubectl create -f nginx-ingress-controller-roles.yaml -n=ingress
kubectl create -f nginx-ingress-controller-deployment.yaml -n=ingress
watch kubectl get pods -o wide
kubectl create -f nginx-ingress.yaml -n=ingress
kubectl create -f app-ingress.yaml
kubectl create -f nginx-ingress-controller-service.yaml -n=ingress
```

* In host

```shell
# VBoxManage modifyvm "worker_node_vm_name" --natpf1 "nodeport,tcp,127.0.0.1,30000,,30000"
# VBoxManage modifyvm "worker_node_vm_name" --natpf1 "nodeport2,tcp,127.0.0.1,32000,,32000"
echo "127.0.0.1 test.example.com" | sudo tee -a /etc/hosts

curl http://test.example.com:30000/app1
curl http://test.example.com:30000/app2
curl http://test.example.com:32000/nginx_status
```
