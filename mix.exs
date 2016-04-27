defmodule ElixirPlugPoc.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_plug_poc,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [ 
      mod: {HelloWorld, []},
      applications: [:logger,:httpoison]
    ]
  end

  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:plug, "~> 1.0"},
      {:cowboy, "~> 1.0"},
      {:httpoison, "~> 0.8.3"}
    ]
  end
end
