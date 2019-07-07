
create-monitoring-namespace:
	kubectl create namespace monitoring || true

create-service-account: create-monitoring-namespace
	kubectl apply --force -f $(shell pwd)/prometheus-service-account.yaml

create-configmap: create-monitoring-namespace
	kubectl apply --force -f $(shell pwd)/prometheus-configmap.yaml

create-deployment:
	kubectl apply --force -f $(shell pwd)/prometheus-deployment.yaml

deploy-prometheus: create-service-account create-configmap create-deployment

port-forward-prometheus: deploy-prometheus
	kubectl port-forward deploy/prometheus-deployment 9090 --namespace=monitoring
