docker-run-prometheus:
	#v2.9.2
	docker run --rm -it -p 9090:9090 -v \
		$(shell pwd)/prometheus/config.yaml:/etc/prometheus.yaml \
		prom/prometheus:v2.9.2 --config.file=/etc/prometheus.yaml
