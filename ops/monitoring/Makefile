deploy-monitoring: 
	kubectl apply --force \
		-f $(shell pwd)/alertmanager-templates.configmap.yaml \
		-f $(shell pwd)/grafana-import-dashboards.configmap.yaml \
		-f $(shell pwd)/prometheus-core.configmap.yaml \
		-f $(shell pwd)/prometheus-rules.configmap.yaml \
		-f $(shell pwd)/manifests-all.yaml \
	&& echo "monitoring applied"

undeploy-monitoring:
	kubectl delete namespace monitoring

port-forward-prometheus:
	kubectl port-forward --namespace=monitoring deploy/prometheus-core 9090 

port-forward-grafana:
	kubectl port-forward --namespace monitoring deploy/grafana-core 3000
