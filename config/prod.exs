use Mix.Config

config :libcluster,
  topologies: [
    k8s_example: [
      strategy: Cluster.Strategy.Kubernetes.DNSSRV,
      config: [
        service: "is-it-up",
        application_name: "is_it_up",
        namespace: {:system, :string, "K8S_NAMESPACE", "elixir"},
        polling_interval: 10_000
      ]
    ]
  ]
