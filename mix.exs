defmodule IsItUp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :is_it_up,
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
      applications: [:confex, :logger, :httpoison, :timex, :cowboy, :plug]
    ]
  end

  def applications(_) do
    [
      applications: [:confex, :prometheus_ex, :cowboy, :httpoison, :timex],
      mod: {IsItUp.App, []}
      # extra_applications: [:confex]
    ]
  end

  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1.5"},
      {:prometheus_process_collector, "~> 1.4"},
      {:confex, "~> 3.4.0"},
      {:distillery, "~> 2.1.1"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:httpoison, "~> 1.5.1"},
      {:libcluster, "~> 3.1"},
      {:plug_cowboy, "~> 2.1.0"},
      {:rexbug, "~> 1.0"},
      {:timex, "~> 3.6"},
      {:telemetry, "~> 0.4.0"}
    ]
  end
end
