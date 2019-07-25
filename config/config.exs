use Mix.Config

# (you should replace this with the name of your plug)
config :prometheus, MetricsPlugExporter,
  path: "/metrics",
  ## or :protobuf, or :text
  format: :auto,
  registry: :default,
  auth: false

config :libcluster,
  debug: {:system, :boolean, "DEBUG_LIBCLUSTER", false}

config :logger,
  level: :info,
  handle_otp_reports: {:system, :boolean, "LOGGER_HANDLE_OTP_REPORTS", false},
  handle_sasl_reports: {:system, :boolean, "LOGGER_HANDLE_SASL_REPORTS", false}

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :is_it_up, :http_port, {:system, :integer, "HTTP_PORT", 4000}
config :is_it_up, :check_init_delay, {:system, :integer, "CHECK_INIT_DELAY", 2}
config :is_it_up, :check_interval, {:system, :integer, "CHECK_INTERVAL", 30}
config :is_it_up, :check_host, {:system, :integer, "CHECK_HOST", "google.com"}

import_config "#{Mix.env()}.exs"
