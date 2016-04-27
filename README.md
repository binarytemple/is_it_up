# ElixirPlugPoc

Trivial example project to demonstrate the use of [Elixir Plug module](https://github.com/elixir-lang/plug).

This first version can be run by executing the following from an console launched with `iex -S mix`:

```
Plug.Adapters.Cowboy.http(HelloWorldPlug, %{})
```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add elixir_plug_poc to your list of dependencies in `mix.exs`:

        def deps do
          [{:elixir_plug_poc, "~> 0.0.1"}]
        end

  2. Ensure elixir_plug_poc is started before your application:

        def application do
          [applications: [:elixir_plug_poc]]
        end

