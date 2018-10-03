### ----------------- glusterfs volume in vagrant instances
glusterv_up: vagrant_reset provision_k8s provision_glusterfs deploy_pod

glusterv_down: vagrant_destroy

glusterv_apply:
	kubectl apply -f ./pv-glusterfs/ep-glusterfs.yaml
	kubectl apply -f ./pv-glusterfs/pv-glusterfs.yaml
	kubectl apply -f ./pv-glusterfs/pvc-glusterfs.yaml
	kubectl apply -f ./pv-glusterfs/nginx-deployment-pvc_glusterfs.yaml
	kubectl apply -f ./pv-glusterfs/nginx-svc_LB.yaml

vagrant_reset:
	-vagrant destroy -f
	#vagrant up
	vagrant up k8sMaster k8sSlave1 k8sSlave2

vagrant_destroy:
	-vagrant destroy -f

provision_k8s:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/provision_k8s.yml
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/setup_k8s_master.yml
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/setup_k8s_worker.yml

provision_glusterfs:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/provision_glusterfs.yml

provision_helm:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/provision_helm.yml

deploy_pod:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/deploy_pod.yml
