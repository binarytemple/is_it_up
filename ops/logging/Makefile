namespace:
	kubectl apply --force -f $(shell pwd)/namespace.yaml

testing-namespace:
	kubectl apply --force -f $(shell pwd)/testing-namespace.yaml

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

deploy-counter-example: testing-namespace
	kubectl apply --force -f $(shell pwd)/counter.yaml

scale-counter-example: deploy-counter-example
	kubectl --namespace testing-kube-logging scale deployment --replicas 10 log-testing-counter

undeploy-counter-example:
	 kubectl delete namespace testing-kube-logging 

deploy: kibana

undeploy-logging:
	kubectl delete namespace kube-logging

port-forward-kibana:
	kubectl --namespace=kube-logging get pod --selector k8s-app=kibana -o json | jq -r ".items[] | .metadata.name" | while read i ; do kubectl port-forward $${i} 5601:5601 --namespace=kube-logging ;done
