HTDOCS ?= $(shell pwd)/htdocs
SHARED_DIR ?= /tmp/k8s
MK_SESSION ?= minikube

localv_k8s_up:
	minikube start

localv_k8s_down:
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

localv_up: localv_k8s_up localv_mount_on localv_apply

localv_down: localv_mount_off localv_k8s_down

localv_results:
	curl $(shell minikube service mynginx --url)

glusterv_apply:
	kubectl apply -f pv-pvc-glusterfs/ep-glusterfs.yaml
	kubectl apply -f pv-pvc-glusterfs/pv-glusterfs.yaml
	kubectl apply -f pv-pvc-glusterfs/pvc-glusterfs.yaml
	kubectl apply -f pv-pvc-glusterfs/nginx-deployment-pvc_glusterfs.yaml
	kubectl apply -f output/nginx-service_LoadBalancer.yaml

monitor_k8s_deploy:
	watch kubectl get deploy,ep,pv,pvc,svc

monitor_k8s_nodes:
	watch kubectl get nodes

glusterv_up: k8s_up glusterv_apply

glusterv_down: k8s_down

vagrant_reset:
	-vagrant destroy -f
	#vagrant up k8sMaster k8sSlave
	vagrant up

glusterv_k8s_up: vagrant_reset provision_k8s setup_k8s_master setup_k8s_worker provision_gluster

provision_k8s:
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/provision_k8s.yml

setup_k8s_master:
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/setup_k8s_master.yml

setup_k8s_worker:
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/setup_k8s_worker.yml

provision_gluster:
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/provision_glusterfs.yml
