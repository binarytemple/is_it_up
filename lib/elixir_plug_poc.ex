defmodule HelloWorld do
  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:elixir_plug_poc)

    http_port = Application.get_env(:elixir_plug_poc, :http_port)

    children = [
      worker(HelloWorld.Timer, []),
      Plug.Cowboy.child_spec(scheme: :http, plug: HelloWorldPipeline, options: [port: 4000])
      Plug.Cowboy.child_spec(scheme: :http, plug: HelloWorldPipeline, options: [port: http_port])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
    {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)
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
     /bt_status - check the status of binarytemple.co.uk
     / <> name  - display a greeting followed by the specified name
    """

    send_resp(conn, 200, "#{available_routes}")
  end

  def call(%Plug.Conn{request_path: "/crash"} = conn, opts) do
    raise "deliberate exception"
  end

  def call(%Plug.Conn{request_path: "/bt_status"} = conn, opts) do
    case HelloWorld.Timer.is_it_up() do
      {:ok, :up} -> send_resp(conn, 200, "binarytemple.co.uk - status - good")
      {:ok, :bad_status} -> send_resp(conn, 200, "binarytemple.co.uk - status - bad")
      _ -> send_resp(conn, 200, "binarytemple.co.uk - status - unknown")
    end
  end

  def call(%Plug.Conn{request_path: "/" <> name} = conn, opts) do
    greeting = "Hello, #{name}!"

    conn
    |> update_resp_header("x-greeting", greeting, & &1)
    |> send_resp(200, greeting)
  end
end

defmodule HelloWorldPipeline do
  # We use Plug.Builder to have access to the plug/2 macro.
  # This macro can receive a function or a module plug and an
  # optional parameter that will be passed unchanged to the 
  # given plug.
  use Plug.Builder

  plug(Plug.Logger)
  plug(HelloWorldPlug, %{})
end
