attach-app-0:
	kubectl -n elixir exec -t -i is-it-up-0 -- bin/is_it_up remote_console

attach-app-1:
	kubectl -n elixir exec -t -i is-it-up-1 -- bin/is_it_up remote_console

mix-run-0:
	HTTP_PORT=4000 iex --cookie foo --name a@127.0.0.1 -S mix

mix-run-1:
	HTTP_PORT=4001 iex --cookie foo --name b@127.0.0.1 -S mix

build:
	docker build  . -f ops/Dockerfile -t binarytemple/is_it_up:latest

docker-run: build
	docker run -ti -p 4000:4000 -e'ERLANG_COOKIE=foo' --rm binarytemple/is_it_up console

push: build
	docker push binarytemple/is_it_up:latest

deploy-app:
	kubectl create namespace elixir || true
	kubectl apply --force --namespace elixir -f ops/app/is-it-up.yaml

undeploy-app:
	kubectl delete namespace elixir || true

deploy-monitoring:
	$(MAKE) -C $(shell pwd)/ops/monitoring/ deploy-monitoring

undeploy-monitoring:
	$(MAKE) -C $(shell pwd)/ops/monitoring/ undeploy-monitoring

deploy-counter-example:
	$(MAKE) -C $(shell pwd)/ops/logging/ deploy-counter-example

undeploy-counter-example:
	$(MAKE) -C $(shell pwd)/ops/logging/ undeploy-counter-example

deploy-logging:
	$(MAKE) -C $(shell pwd)/ops/logging/ deploy

undeploy-logging:
	$(MAKE) -C $(shell pwd)/ops/logging/ undeploy-logging

backup-monitoring-secrets:
	kubectl create namespace backup || true
	kubectl get secret grafana --namespace=monitoring --export -o yaml | kubectl apply --namespace=backup -f -

rerun-grafana-import-dashboards:
	$(MAKE) -C $(shell pwd)/ops/monitoring/ rerun-grafana-import-dashboards

restore-monitoring-secrets:
	kubectl get secret grafana --namespace=backup --export -o yaml | kubectl apply --namespace=monitoring -f -

port-forward-prometheus:
	$(MAKE) -C $(shell pwd)/ops/monitoring/ port-forward-prometheus

port-forward-grafana:
	$(MAKE) -C $(shell pwd)/ops/monitoring/ port-forward-grafana

port-forward-elixir:
	kubectl port-forward --namespace elixir is-it-up-0 14000:4000

port-forward-kibana:
	$(MAKE) -C $(shell pwd)/ops/logging/ port-forward-kibana

kaniko-build:
	docker run -ti --rm -v $(shell pwd):/workspace \
		-v $${HOME}/.buildsecrets/irishjava.json:/kaniko/.docker/.docker/config.json:ro \
		gcr.io/kaniko-project/executor:latest \
		--dockerfile=ops/Dockerfile \
		--no-push \
		--destination=docker.io/onlytestingdonotuse/test:latest
