include ./config.mk
include Makefiles/monitor.mk
include Makefiles/k8s.mk
include Makefiles/local.mk
include Makefiles/glusterfs.mk
include Makefiles/gcePersistentDisk.mk
include Makefiles/haproxy.mk

ping_ansible:
	ansible all -i ${INVENTORY} -m ping

facts_ansible:
	ansible all -i ${INVENTORY} -m setup



gce_instances:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/gce_instance.yml

deploy_all: ping_ansible provision_k8s deploy_code



deploy_code:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/deploy_code.yml







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
