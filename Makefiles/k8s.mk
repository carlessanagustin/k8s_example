LIMIT ?= -l master2
node_name ?= k8s-test-worker-001
service ?= kubelet.service

provision_k8s:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/provision_k8s.yml
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/setup_k8s_master.yml
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/setup_k8s_worker.yml

recover_k8s_master:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/provision_k8s.yml ${LIMIT}
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/setup_k8s_master.yml ${LIMIT}

# @master old
delete_node:
	kubectl cordon ${node_name}
	#kubectl drain ${node_name} --grace-period=0 --force
	kubectl delete node ${node_name} --force

# @master new
get_token:
	kubeadm token create --print-join-command

# @worker
attach_node:
	sudo systemctl stop ${service}
	sudo rm -f /etc/kubernetes/pki/ca.crt
	sudo rm -f /etc/kubernetes/kubelet.conf
	sudo rm -f /etc/kubernetes/bootstrap-kubelet.conf
	sudo kubeadm ... (from get_token)
