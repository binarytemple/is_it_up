use Mix.Config

config :libcluster,
  topologies: [
    k8s_example: [
      strategy: Cluster.Strategy.Kubernetes.DNSSRV,
      config: [
        service: "elixir-plug-poc",
        application_name: "elixir_plug_poc",
        namespace: "default",
        polling_interval: 10_000
      ]
    ]
  ]
