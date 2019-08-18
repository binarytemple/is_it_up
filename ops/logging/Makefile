
namespace:
	kubectl apply --force -f $(shell pwd)/namespace.yaml

volume:
	kubectl apply --force -f $(shell pwd)/volume.yaml

elasticsearch: namespace volume
	kubectl apply --force \
		-f $(shell pwd)/elasticsearch_statefulset.yaml \
		-f $(shell pwd)/elasticsearch_svc.yaml

kibana: elasticsearch fluentd
	kubectl apply --force -f $(shell pwd)/kibana.yaml

fluentd:
	kubectl apply --force -f $(shell pwd)/fluentd.yaml

deploy-counter-example: namespace
	kubectl apply --force -f $(shell pwd)/counter.yaml

deploy: kibana

undeploy-logging:
	kubectl delete namespace kube-logging

port-forward-kibana:
	kubectl --namespace=kube-logging get pod --selector app=kibana -o json | jq -r ".items[] | .metadata.name" | while read i ; do kubectl port-forward $${i} 5601:5601 --namespace=kube-logging ;done
