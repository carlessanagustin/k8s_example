
kubectl create -f app-deployment.yaml -f app-service.yaml


kubectl delete svc appsvc1
kubectl delete svc appsvc2
kubectl delete deploy app1
kubectl delete deploy app2
