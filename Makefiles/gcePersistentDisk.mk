### ----------------- gcePersistentDisk volume in GCP instances
gcev_apply:
	#@read -p "pvc continue? " -n 1 response
	kubectl apply -f ./pv-gcePersistentDisk/pvc-gcePersistentDisk.yaml
	kubectl apply -f ./pv-gcePersistentDisk/nginx-deployment-pvc_gcePersistentDisk.yaml
	kubectl apply -f ./pv-gcePersistentDisk/nginx-svc_LB.yaml

gcev_unapply:
	-kubectl delete svc mynginx
	-kubectl delete deploy nginx
	-kubectl delete pvc gce-pvc

# echo "This is a GKE test" > /usr/share/nginx/html/index.html
