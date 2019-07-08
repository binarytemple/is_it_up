use Mix.Config

config :libcluster,
  topologies: [
    k8s_example: [
      strategy: Cluster.Strategy.Kubernetes.DNSSRV,
      config: [
        service: "is-it-up",
        application_name: "is_it_up",
        namespace: "default",
        polling_interval: 10_000
      ]
    ]
  ]
