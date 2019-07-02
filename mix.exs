defmodule ElixirPlugPoc.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_plug_poc,
      version: "0.0.1",
      elixir: "~> 1.8",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    applications(Mix.env())
  end

  def applications(:test) do
    [
      applications: [:logger, :httpoison, :timex, :cowboy, :plug]
    ]
  end

  def applications(_) do
    [
      mod: {HelloWorld, []},
      applications: [:logger, :httpoison, :timex, :cowboy, :plug, :plug_cowboy]
    ]
  end

  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:plug_cowboy, "~> 2.1.0"},
      {:httpoison, "~> 1.5.1"},
      {:distillery, "~> 2.1.1"},
      {:timex, "~> 3.6.1 "},
    ]
  end
end
