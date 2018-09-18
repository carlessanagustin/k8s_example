HTDOCS ?= $(shell pwd)/htdocs
SHARED_DIR ?= /tmp/k8s
MK_SESSION ?= minikube

k8s_up:
	minikube start

k8s_down:
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

localv_up: k8s_up localv_mount_on localv_apply

localv_down: localv_mount_off k8s_down

glusterv_apply:
	kubectl apply -f pv-pvc-glusterfs/ep-glusterfs.yaml
	kubectl apply -f pv-pvc-glusterfs/pv-glusterfs.yaml
	kubectl apply -f pv-pvc-glusterfs/pvc-glusterfs.yaml
	kubectl apply -f pv-pvc-glusterfs/nginx-deployment-pvc_glusterfs.yaml
	kubectl apply -f output/nginx-service_LoadBalancer.yaml

glusterv_up: k8s_up glusterv_apply

glusterv_down: k8s_down

results:
	curl $(shell minikube service mynginx --url)

provision_k8s:
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/provision_k8s.yml

setup_k8s:
	ansible-playbook -i ./ansible/inventory/hosts ./ansible/playbooks/setup_k8s.yml

vagrant_up: provision_k8s setup_k8s
