ANSIBLE_FOLDER ?= ./ansible/playbooks

####### kubernetes: create
provision_k8s: install_k8s setup_k8s_master setup_k8s_worker

install_k8s:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_k8s.yml ${LIMIT} ${TAG} ${DEBUG}

setup_k8s_master:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/setup_k8s_master.yml ${LIMIT} ${TAG} ${DEBUG}

setup_k8s_worker:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/setup_k8s_worker.yml ${LIMIT} ${TAG} ${DEBUG}

####### kubernetes: rejoin
provision_k8s_rejoin: install_k8s setup_k8s_master setup_k8s_worker_rejoin

setup_k8s_worker_rejoin:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/setup_k8s_worker.yml --extra-vars UNJOIN=true ${LIMIT} ${TAG} ${DEBUG}

####### glusterfs
provision_glusterfs:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_glusterfs.yml --extra-vars GSERVER_IP=${GSERVER_IP} ${LIMIT} ${TAG} ${DEBUG}

####### gcp instances
gce_instances:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/gce_instance.yml

####### worldsensing actions
deploy_code:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/deploy_code.yml --extra-vars GSERVER_IP=${GSERVER_IP} ${LIMIT} ${TAG} ${DEBUG}

####### ansible help
ping_ansible:
	ansible all -i ${INVENTORY} -m ping

facts_ansible:
	ansible all -i ${INVENTORY} -m setup

####### helm
provision_helm:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_helm.yml ${LIMIT} ${TAG} ${DEBUG}
