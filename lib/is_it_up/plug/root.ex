defmodule IsItUp.Plug.Root do
  import Plug.Conn

  alias IsItUp.Checker

  @spec init(map) :: %{my_prefix: <<_::40>>}
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
    case Checker.is_it_up() do
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
