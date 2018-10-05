app_apply:
	kubectl apply -f ./lb-haproxy/app-deployment.yaml
	kubectl apply -f ./lb-haproxy/app-service.yaml

app_delete:
	kubectl delete svc appsvc1
	kubectl delete svc appsvc2
	kubectl delete deploy app1
	kubectl delete deploy app2

haproxy_up:
	docker-compose -f ./lb-haproxy/docker-compose.yml up -d
