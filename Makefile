HTDOCS ?= $(shell pwd)/htdocs
SHARED_DIR ?= /tmp/k8s
MK_SESSION ?= minikube

POD_NAMESPACE ?= ingress-nginx


# ----------------- local volume in MINIKUBE
localv_up: minikube_up localv_mount_on localv_apply

localv_down: localv_mount_off minikube_down

minikube_up:
	minikube start

minikube_down:
	minikube delete

localv_mount_on:
	tmux new-session -d -s ${MK_SESSION} minikube mount ${HTDOCS}:${SHARED_DIR}

localv_mount_off:
	-tmux kill-session -t ${MK_SESSION}

localv_apply:
	kubectl apply -f pv-pvc-local/pvc-local.yaml
	kubectl apply -f pv-pvc-local/pv-local.yaml
	kubectl apply -f pv-pvc-local/nginx-deployment-pvc_local.yaml
	kubectl apply -f output/nginx-service_LoadBalancer.yaml

localv_results:
	curl $(shell minikube service mynginx --url)



test: vagrant_reset provision_k8s
### ----------------- glusterfs volume in vagrant instances
glusterv_up: vagrant_reset provision_k8s provision_glusterfs deploy_pod

glusterv_down: vagrant_destroy

glusterv_apply:
	kubectl apply -f ./pv-pvc-glusterfs/ep-glusterfs.yaml
	kubectl apply -f ./pv-pvc-glusterfs/pv-glusterfs.yaml
	kubectl apply -f ./pv-pvc-glusterfs/pvc-glusterfs.yaml
	kubectl apply -f ./pv-pvc-glusterfs/nginx-deployment-pvc_glusterfs.yaml
	kubectl apply -f ./pv-pvc-glusterfs/nginx-svc_LB.yaml

vagrant_reset:
	-vagrant destroy -f
	vagrant up

vagrant_destroy:
	-vagrant destroy -f

provision_k8s:
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/provision_k8s.yml
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/setup_k8s_master.yml
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/setup_k8s_worker.yml

provision_glusterfs:
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/provision_glusterfs.yml

deploy_pod:
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/deploy_pod.yml


### ----------------- monitoring k8s commands
monitor_k8s_deploy:
	watch kubectl get deploy,ep,pv,pvc -o wide

monitor_k8s_svc:
	watch kubectl get svc -o wide

monitor_k8s_nodes:
	watch kubectl get node -o wide

monitor_k8s_all:
	watch kubectl get deploy,ep,pv,pvc,ingress,nodes,svc -o wide


### ----------------- ingress / load balancer
# docs: https://kubernetes.github.io/ingress-nginx/deploy/
ingress_nginx:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/baremetal/service-nodeport.yaml

#ingress_nginx_verify:
#	 kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx --watch
#  POD_NAME := $(shell kubectl get pods -n ${POD_NAMESPACE} -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{.items[0].metadata.name}')
#  kubectl exec -it ${POD_NAME} -n ${POD_NAMESPACE} -- /nginx-ingress-controller --version

ingress_nginx_gce:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

# docs: https://metallb.universe.tf/concepts/
metallb_system:
	kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml
