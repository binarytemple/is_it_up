use Mix.Config

config :logger,
  level: :info,
  handle_otp_reports: false,
  handle_sasl_reports: false

config :elixir_plug_poc,
  http_port: 4001,
  check_init_delay: 2,
  check_interval: 30,
  check_host: "google.com"

# in test we don't do anything with libcluster
config :libcluster,
  topologies: []
