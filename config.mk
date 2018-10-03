HTDOCS ?= $(shell pwd)/pv-local
SHARED_DIR ?= /tmp/k8s
MK_SESSION ?= minikube
POD_NAMESPACE ?= ingress-nginx

# local-ssd | pd-ssd | pd-standard
VTYPE ?= pd-standard
VNAME ?= gke-my-data-disk
VZONE ?= europe-west1-b
VSIZE ?= 10GB

#INVENTORY ?= ./ansible/inventory/vagrant
INVENTORY ?= ./ansible/inventory/gcp
