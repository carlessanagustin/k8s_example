glusterv_up: vagrant_reset provision_k8s provision_glusterfs deploy_pod

glusterv_down: vagrant_destroy

glusterv_apply:
	kubectl apply -f ./pv-glusterfs/ep-glusterfs.yaml
	kubectl apply -f ./pv-glusterfs/pv-glusterfs.yaml
	kubectl apply -f ./pv-glusterfs/pvc-glusterfs.yaml
	kubectl apply -f ./pv-glusterfs/nginx-deployment-pvc_glusterfs.yaml
	kubectl apply -f ./pv-glusterfs/nginx-svc_LB.yaml

glusterv_delete:
	kubectl delete -f ./pv-glusterfs/nginx-svc_LB.yaml
	kubectl delete -f ./pv-glusterfs/nginx-deployment-pvc_glusterfs.yaml
	kubectl delete -f ./pv-glusterfs/pvc-glusterfs.yaml
	kubectl delete -f ./pv-glusterfs/pv-glusterfs.yaml
	kubectl delete -f ./pv-glusterfs/ep-glusterfs.yaml

vagrant_reset:
	-vagrant destroy -f
	#vagrant up
	vagrant up k8sMaster k8sSlave1 k8sSlave2

vagrant_destroy:
	-vagrant destroy -f

provision_glusterfs:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/provision_glusterfs.yml --extra-vars GSERVER_IP=10.132.0.20
	# vagrant: ansible-playbook -i ${INVENTORY} ./ansible/playbooks/provision_glusterfs.yml --extra-vars GSERVER_IP=192.168.32.10

provision_helm:
	ansible-playbook -i ${INVENTORY} ./ansible/playbooks/provision_helm.yml
