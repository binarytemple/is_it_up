defmodule HelloWorld do
  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:logger)
    Logger.configure(Application.get_all_env(:logger))
    Confex.resolve_env!(:elixir_plug_poc)
    MetricsPlugExporter.setup()

    http_port = Application.get_env(:elixir_plug_poc, :http_port)

    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      %{
        id: HelloWorld.Timer,
        start: {HelloWorld.Timer, :start_link, []},
        restart: :permanent,
        shutdown: 5000,
        type: :worker
      },
      {Cluster.Supervisor, [topologies, [name: ClusterSupervisor]]},
      Plug.Cowboy.child_spec(scheme: :http, plug: HelloWorldPipeline, options: [port: http_port])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

defmodule HelloWorldPlug do
  import Plug.Conn

  def init(opts) do
    Map.put(opts, :my_prefix, "Hello")
  end

  def call(%Plug.Conn{request_path: "/"} = conn, opts) do
    available_routes = """
     #{opts[:my_prefix]}, World!
     /          - this message
     /crash     - throw an exception, crash the plug process
     /google_status - check the status of google.co.uk
     /metrics - check the status of google.co.uk
     / <> name  - display a greeting followed by the specified name
    """

    send_resp(conn, 200, "#{available_routes}")
  end

  def call(%Plug.Conn{request_path: "/crash"}, _opts) do
    raise "deliberate exception"
  end

  def call(%Plug.Conn{request_path: "/google_status"} = conn, _opts) do
    case HelloWorld.Timer.is_it_up() do
      {:ok, true} ->
        send_resp(conn, 200, "google.co.uk - status - good")

      {:ok, false} ->
        send_resp(conn, 200, "google.co.uk - status - bad")
        #  x -> send_resp(conn, 200, "google.co.uk - status - #{IO.inspect(x)}")
    end
  end

  def call(%Plug.Conn{request_path: "/" <> name} = conn, _opts) do
    greeting = "Hello, #{name}!"

    conn
    |> update_resp_header("x-greeting", greeting, & &1)
    |> send_resp(200, greeting)
  end
end

defmodule MetricsPlugExporter do
  use Prometheus.PlugExporter
  # def init(x) do
  #   x
  # end
end

defmodule HelloWorldPipeline do
  # We use Plug.Builder to have access to the plug/2 macro.
  # This macro can receive a function or a module plug and an
  # optional parameter that will be passed unchanged to the
  # given plug.
  use Plug.Builder
  plug(Plug.Logger)
  plug(MetricsPlugExporter, %{})
  plug(HelloWorldPlug, %{})
end

defmodule CheckInstrumenter do
  use Prometheus.Metric
  alias Prometheus.Metric.{Boolean, Counter, Gauge, Histogram, Summary}

  @counter [
    name: :http_check_total,
    help: "counter incremeted for every http request upstream",
    labels: [:target]
  ]

  @histogram [
    name: :http_check_duration_milliseconds,
    labels: [:value],
    buckets: :default,
    help: "Http check execution time"
  ]

  @spec http_check(String.t()) :: any
  def http_check(target) do
    Counter.inc(
      name: :http_check_total,
      labels: [target]
    )
  end

  @spec http_check_duration_milliseconds(any) :: any
  def http_check_duration_milliseconds(time) do
    Histogram.observe([name: :http_check_duration_milliseconds,
    labels: [:value]], time)
  end
end
