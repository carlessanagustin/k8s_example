include ./config.mk
include Makefiles/monitor.mk
include Makefiles/k8s.mk
include Makefiles/local.mk
include Makefiles/glusterfs.mk
include Makefiles/gcePersistentDisk.mk
include Makefiles/haproxy.mk
include Makefiles/ansible.mk

## create instances
step1: gce_instances

# steps1.A manual@local
# update ansible inventory: `./ansible/inventory/gcp`

## provision k8s master & k8s workers
step2: ping_ansible provision_k8s

## provision glusterfs
step3: provision_glusterfs

## deploy code to k8s master (software) & gluster (configuration & data)
step4: deploy_code

## deploy haproxy
step5: provision_haproxy

# step manual@haproxy:
# `cd /opt/haproxy`
# change `sudo vim haproxy.cfg` with ports
#     from `kubectl get svc`
# run: `sudo make up`

step_rejoin: LIMIT="-l master2" install_k8s setup_k8s_master setup_k8s_worker_rejoin
# step2.A manual@haproxy: ...

steps_auto: step2 step3 step4 step5






requirements:
	sudo apt-get update && sudo apt-get -y install make git ansible
	sudo git clone https://github.com/carlessanagustin/k8s_example.git /opt/k8s_example
	# user with `ALL=(ALL) NOPASSWD:ALL` in `/etc/sudoers`


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
