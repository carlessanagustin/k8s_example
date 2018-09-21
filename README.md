# Simple Kubernetes  example

This is a group examples to deploy a Nginx service in a Kubernetes (k8s) environment. For this purpose we'll use these tools: Make, Docker Engine, Docker Compose, Vagrant, Minikube, KVM2, VirtualBox, Kubectl, Kubeadm, GlusterFS, Ansible.

## [Part I: Deploy Nginx](./README_PartI.md)

* Usage of kubctl commands to manually deploy an Nginx container in a K8s cluster.
* Using Kompose to convert a Nginx docker-compose.yml file into k8s yaml files.

## [Part II: Deploy Nginx with storage](./README_PartII.md)

* Local volume
* GlusterFS volume
* Google Compute Engine (GCE) Persistent Disk volume

*More k8s Types of Volumes: https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes*
