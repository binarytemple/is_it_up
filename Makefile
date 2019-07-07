build:
	docker build  . -f ops/Dockerfile -t binarytemple/elixir_plug_poc:latest

docker-run: build
	docker run -ti -p 4000:4000 -e'ERLANG_COOKIE=foo' --rm binarytemple/elixir_plug_poc console

push: build
	docker push binarytemple/elixir_plug_poc:latest

deploy-app:
	kubectl create namespace elixir || true
	kubectl apply --force --namespace elixir -f ops/app/elixir-plug-poc.yaml

undeploy-app:
	kubectl delete namespace elixir || true

deploy-monitoring:
	$(MAKE) -C $(shell pwd)/ops/monitoring/ deploy-monitoring

undeploy-monitoring:
	$(MAKE) -C $(shell pwd)/ops/monitoring/ undeploy-monitoring

backup-monitoring-secrets:
	kubectl create namespace backup || true
	kubectl get secret grafana --namespace=monitoring --export -o yaml | kubectl apply --namespace=backup -f -

restore-monitoring-secrets:
	kubectl get secret grafana --namespace=backup --export -o yaml | kubectl apply --namespace=monitoring -f -

port-forward-prometheus:
	$(MAKE) -C $(shell pwd)/ops/monitoring/ port-forward-prometheus

port-forward-grafana:
	$(MAKE) -C $(shell pwd)/ops/monitoring/ port-forward-grafana

port-forward-elixir:
	kubectl port-forward --namespace elixir elixir-plug-poc-0 4000  
