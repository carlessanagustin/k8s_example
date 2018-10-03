monitor_k8s_describe:
	kubectl describe pods

monitor_k8s_pods:
	watch kubectl get pods -o wide

monitor_k8s_svc:
	watch kubectl get svc -o wide

monitor_k8s_nodes:
	watch kubectl get node -o wide

monitor_k8s_deploy:
	watch kubectl get pods,deploy,svc -o wide

monitor_k8s_all:
	watch kubectl get pods,deploy,ep,pv,pvc,ingress,nodes,svc -o wide

monitor_k8s_events:
	watch "kubectl get events --sort-by=.metadata.creationTimestamp | tac"
