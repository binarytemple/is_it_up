use Mix.Config

config :libcluster,
  topologies: [
    k8s_example: [
      strategy: Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: "elixir-plug-poc",
        application_name: "elixir-plug-poc",
        polling_interval: 10_000
      ]
    ]
  ]
