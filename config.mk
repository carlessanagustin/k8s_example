POD_NAMESPACE ?= ingress-nginx

#INVENTORY ?= ./ansible/inventory/vagrant
INVENTORY ?= ./ansible/inventory/gcp

LIMIT ?=
TAG ?=
DEBUG ?=
NODE_NAME ?= k8s-test-worker-001
GRACE_PERIOD ?= 15
