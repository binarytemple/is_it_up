deploy-monitoring: 
	kubectl apply --force -f $(shell pwd)/manifests-all.yaml

undeploy-monitoring:
	kubectl delete namespace monitoring

port-forward-prometheus:
	kubectl port-forward --namespace=monitoring deploy/prometheus-core 9090 

port-forward-grafana:
	kubectl port-forward --namespace monitoring deploy/grafana-core 3000
