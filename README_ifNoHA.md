# if gluster server goes down?

Backup files from
- S_FOLDER: '/data/k8'

Steps to follow after server went down:
- nothing to do

Steps to create new server:
- playbook: ./ansible/playbooks/provision_glusterfs.yml

# if k8s master server goes down?

nothing while workers are up-n-running

# if haproxy server goes down?


# if everything goes does down?

bring back up & fine!

# replacing k8s master?

see k8s.mk


## The grace period for deleting pods on failed nodes.
# watch kubectl get pods --all-namespaces
# sudo vim /etc/kubernetes/manifests/kube-controller-manager.yaml
# --pod-eviction-timeout=0m30s
## https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/
## https://github.com/kubernetes/kubernetes/issues/55713
