provision_k8s:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/provision_k8s.yml
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/setup_k8s_master.yml
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/setup_k8s_worker.yml
