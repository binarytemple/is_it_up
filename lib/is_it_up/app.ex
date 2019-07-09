defmodule IsItUp.App do
  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:logger)
    Logger.configure(Application.get_all_env(:logger))
    Confex.resolve_env!(:libcluster)
    Confex.resolve_env!(:is_it_up)
    IsItUp.Metrics.PlugExporter.setup()

    http_port = Application.get_env(:is_it_up, :http_port)

    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      %{
        id: IsItUp.Checker,
        start: {IsItUp.Checker, :start_link, []},
        restart: :permanent,
        shutdown: 5000,
        type: :worker
      },
      {Cluster.Supervisor, [topologies, [name: ClusterSupervisor]]},
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: IsItUp.Plug.Pipeline,
        options: [port: http_port]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
