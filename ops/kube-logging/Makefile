deploy-monitoring:
	kubectl apply --force \
		-f $(shell pwd)/namespace.yaml \
		-f $(shell pwd)/monitoring-sample.secret.yaml \
		-f $(shell pwd)/alertmanager-templates.configmap.yaml \
		-f $(shell pwd)/prometheus-core.configmap.yaml \
		-f $(shell pwd)/prometheus-rules.configmap.yaml
	kubectl -n monitoring delete configmap grafana-import-dashboards  || true
	kubectl -n monitoring create configmap grafana-import-dashboards \
		--from-file $(shell pwd)/config/grafana-import-dashboards  || true
	kubectl apply --force \
		-f $(shell pwd)/manifests-all.yaml \
		-f $(shell pwd)/grafana-import-dashboards.job.yaml


undeploy-logging:
	kubectl delete namespace logging

#port-forward-prometheus:
#	kubectl port-forward --namespace=monitoring deploy/prometheus-core 9090
#
#port-forward-grafana:
#	kubectl port-forward --namespace monitoring deploy/grafana-core 3000
