# create master2 instance
# # @ local
# make install_k8s LIMIT="-l master2"
# make setup_k8s_master LIMIT="-l master2"
# make deploy_code LIMIT="-l master2" TAG="-t git"

# @master old
delete_node:
	kubectl cordon ${NODE_NAME}
	kubectl delete node ${NODE_NAME} --grace-period=${GRACE_PERIOD}
	sleep ${GRACE_PERIOD}

# make provision_k8s_rejoin

### # @master new
### get_token:
### 	kubeadm token create --print-join-command
###
### # @worker
### dettach_node:
### 	sudo systemctl stop kubelet.service
### 	sudo rm -f /etc/kubernetes/pki/ca.crt
### 	sudo rm -f /etc/kubernetes/kubelet.conf
### 	sudo rm -f /etc/kubernetes/bootstrap-kubelet.conf
###
### attach_node:
### 	sudo kubeadm ... (from get_token)


# make glusterv_apply

# `cd /opt/k8s_example`
# change `sudo vim lb-haproxy/haproxy.cfg` with ports
#     from `kubectl get svc`
# run: `sudo make haproxy_restart`











#####
