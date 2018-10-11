HTDOCS ?= $(shell pwd)/pv-local
SHARED_DIR ?= /data/k8s
MK_SESSION ?= minikube

localv_up: minikube_up localv_mount_on localv_apply

localv_down: localv_mount_off minikube_down

minikube_up:
	-minikube start

minikube_down:
	-minikube delete

localv_mount_on:
	tmux new-session -d -s ${MK_SESSION} minikube mount ${HTDOCS}:${SHARED_DIR}

localv_mount_off:
	-tmux kill-session -t ${MK_SESSION}

localv_apply:
	kubectl apply -f pv-local/pvc-local.yaml
	kubectl apply -f pv-local/pv-local.yaml
	kubectl apply -f pv-local/nginx-deployment-pvc_local.yaml
	kubectl apply -f pv-local/nginx-service_LoadBalancer.yaml

localv_results:
	curl $(shell minikube service mynginx --url)
