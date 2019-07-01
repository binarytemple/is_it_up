defmodule HelloWorldPlugTest do
  use ExUnit.Case
  use ExUnit.Case, async: true
  use Plug.Test

  @opts HelloWorldPlug.init(%{})

  test "returns 'Hello, World!'" do
    conn = conn(:get, "/")

    # Invoke the plug
    conn = HelloWorldPlug.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ "Hello, World!"
  end

  test "returns 'Hello, Torben!'" do
    conn = conn(:get, "/Torben")

    # Invoke the plug
    conn = HelloWorldPlug.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, Torben!"
  end
end
