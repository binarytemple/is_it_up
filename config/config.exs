use Mix.Config

config :libcluster,
  debug: true

config :logger, level: :info

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :elixir_plug_poc, :http_port, {:system, :integer, "HTTP_PORT", 4000}
config :elixir_plug_poc, :check_init_delay, {:system, :integer, "CHECK_INIT_DELAY", 2}
config :elixir_plug_poc, :check_interval, {:system, :integer, "CHECK_INTERVAL", 30}
config :elixir_plug_poc, :check_host, {:system, :integer, "CHECK_HOST", "google.com"}

import_config "#{Mix.env()}.exs"
