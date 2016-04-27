defmodule HelloWorld do
  use Application

  def start(_type, _args) do
      # The Cowboy has it's own supervision tree.. no need for supervisor
      Plug.Adapters.Cowboy.http(HelloWorldPlug, %{})

      # Import helpers for defining supervisors
      import Supervisor.Spec

      children = [
        worker(HelloWorld.Timer,[])
      ]

      # Start the supervisor with our one child
      {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)

  end
end

defmodule HelloWorldPlug do
  import Plug.Conn

  def init(opts) do
    Map.put(opts, :my_prefix, "Hello")
  end

  def call(%Plug.Conn{request_path: "/" } = conn, opts) do
    available_routes = """
                       #{opts[:my_prefix]}, World!
                       /          - this message
                       /crash     - throw an exception, crash the plug process
                       /bt_status - check the status of binarytemple.co.uk
                       / <> name  - display a greeting followed by the specified name
                      """
    send_resp(conn, 200, "#{available_routes}")
  end

  def call(%Plug.Conn{request_path: "/crash" } = conn, opts) do
    raise "deliberate exception"
  end

  def call(%Plug.Conn{request_path: "/bt_status" } = conn, opts) do
    case HelloWorld.Timer.is_it_up do
      {:ok, :up} -> send_resp(conn, 200, "binarytemple.co.uk - status - good" )
      {:ok, :bad_status} -> send_resp(conn, 200, "binarytemple.co.uk - status - bad")
      _ ->  send_resp(conn, 200, "binarytemple.co.uk - status - unknown")
    end
  end

  def call(%Plug.Conn{request_path: "/" <> name} = conn, opts) do
    send_resp(conn, 200, "Hello, #{name}!")
  end

end
