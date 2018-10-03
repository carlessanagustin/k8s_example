include Makefiles/monitor.mk
include Makefiles/local.mk
include Makefiles/glusterfs.mk
include Makefiles/gcePersistentDisk.mk
#include Makefiles/haproxy.mk

HTDOCS ?= $(shell pwd)/htdocs
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

test_ansible:
	ansible all -i ${INVENTORY} -m ping

test_all: provision_k8s provision_code

provision_code:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/provision_code.yml

gce_instances:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/gce_instance.yml



k8s_up: vagrant_reset provision_k8s provision_helm

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
