include ./config.mk
include Makefiles/monitor.mk
include Makefiles/k8s.mk
include Makefiles/local.mk
include Makefiles/glusterfs.mk
include Makefiles/gcePersistentDisk.mk
include Makefiles/haproxy.mk

# steps

step1: gce_instances
# @local
# add IPs to `./ansible/inventory/gcp`
step2: ping_ansible provision_k8s provision_glusterfs deploy_code
# @haproxy:
# cd /opt/k8s_example
# change `sudo vim lb-haproxy/haproxy.cfg` with ports from `kubectl get svc appsvc1 -o json`
# run: `sudo make haproxy_up`



gce_instances:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/gce_instance.yml

deploy_code:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/deploy_code.yml

requirements:
	sudo apt-get update && sudo apt-get -y install make git ansible
	sudo git clone https://github.com/carlessanagustin/k8s_example.git /opt/k8s_example

# ansible help
ping_ansible:
	ansible all -i ${INVENTORY} -m ping

facts_ansible:
	ansible all -i ${INVENTORY} -m setup



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
