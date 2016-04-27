defmodule HelloWorld do
  use Application

  def start(_type, _args) do
      Plug.Adapters.Cowboy.http(HelloWorldPlug, %{})
  end
end

defmodule HelloWorldPlug do

  import Plug.Conn

  def init(opts) do
    Map.put(opts, :my_prefix, "Hello")
  end

  def call(%Plug.Conn{request_path: "/" } = conn, opts) do
    send_resp(conn, 200, "#{opts[:my_prefix]}, World!")
  end

  def call(%Plug.Conn{request_path: "/" <> name} = conn, opts) do
    send_resp(conn, 200, "Hello, #{name}!")
  end

end
