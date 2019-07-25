[![CI status](https://travis-ci.org/bryanhuntesl/ex_bench.svg?branch=master)](https://travis-ci.org/bryanhuntesl/ex_bench)

# is_it_up

A testbed for deploying and monitoring clustered Elixir applications in Kubernetes - with Prometheus monitoring and Grafana metrics display.

## ex_bench supported

This project builds with [ex_bench](https://github.com/bryanhuntesl/ex_bench/) support

## todo 

* Servers to poll stored in database rather than single hard coded target (google.com)
* Add [eflame dependency](https://github.com/esl/eflame) to identify process bottlenecks
* Build using Erlang 22 with https://hub.docker.com/r/bryanhuntesl/alpine-erlang and [S.L. Fritchie eflame patch](https://github.com/bryanhuntesl/alpine-erlang/blob/experiment/slfritchie-eflame-enhancements/patches/slfritchie-eflame.patch)


## running

See the Makefile for all available tasks - the tasks are currently : 

| Command                            | Description                                                                                                                               |
| ---------------------------------- | -----------                                                                                                                               |
| `attach-app-0`                     | attach to first instance of app running in stateful set                                                                                   |
| `attach-app-1`                     | attach to second instance of app running in stateful set                                                                                  |
| `backup-monitoring-secrets`        | backup the monitoring secrets to namespace `backup`                                                                                       |
| `build`                            | build the application into a docker image                                                                                                 |
| `deploy-app`                       | deploy the application to k8s namespace `elixir`                                                                                          |
| `deploy-monitoring`                | deploy the monitoring tools (prometheus/grafana) to namespace `monitoring`                                                                |
| `docker-run`                       | run single instance of the image in docker (no kubenetes involved)                                                                        |
| `kaniko-build`                     | build the docker image using kaniko (rootless, runs as a kubernetes job)                                                                  |
| `mix-run-0`                        | run instance 0 of the application using iex/mix (dev mode, libcluster hard coded 2 nodes)                                                 |
| `mix-run-1`                        | run instance 1 of the application using iex/mix (dev mode, libcluster hard coded 2 nodes)                                                 |
| `port-forward-elixir`              | port forward the first elixir container to localhost (14000) so you can access via http                                                   |
| `port-forward-grafana`             | port forward the grafana container to localhost (3000) so you can access via http                                                         |
| `port-forward-prometheus`          | port forward the prometheus container to localhost (9090) so you can access via http                                                      |
| `push`                             | push the project to docker hub                                                                                                            |
| `rerun-grafana-import-dashboards`  | tweaking grafana dashboards, export via gui, copy to ops/monitoring/config/grafana-import-dashboards and run to verify import still works |
| `restore-monitoring-secrets`       | destroyed the monitoring namespace, use this to avoid having to re-enter the required secrets                                                                                                                                           |
| `undeploy-app`                     | destroy the elixir namespace                                                                                                                                           |
| `undeploy-monitoring`              | destroy the monitoring namespace                                                                                                                                           |






