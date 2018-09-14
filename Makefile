HTDOCS ?= $(shell pwd)/htdocs
SHARED_DIR ?= /tmp/k8s
MK_SESSION ?= minikube

minikube_up:
	minikube start
	tmux new-session -d -s ${MK_SESSION} minikube mount ${HTDOCS}:${SHARED_DIR}
	@sleep 3

minikube_down:
	-tmux kill-session -t ${MK_SESSION}
	minikube delete

local_volume:
	kubectl apply -f pv-pvc-local/pvc-local.yaml
	kubectl apply -f pv-pvc-local/pv-local.yaml
	kubectl apply -f pv-pvc-local/nginx-deployment-pvc_local.yaml
	kubectl apply -f output/nginx-service_LoadBalancer.yaml

local_volume_up: minikube_up local_volume

results:
	curl $(shell minikube service mynginx --url)
