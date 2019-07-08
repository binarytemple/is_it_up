defmodule IsItUp.Metrics.Instrumenter do

  use Prometheus.Metric
  alias Prometheus.Metric.{Counter, Histogram}
  require Logger
  @counter [
    name: :http_check_total,
    help: "counter incremeted for every http request upstream",
    labels: [:target]
  ]

  @histogram [
    name: :http_check_duration_milliseconds,
    labels: [:value],
    buckets: :default,
    help: "Http check execution time"
  ]

  @spec http_check(String.t()) :: any
  def http_check(target) do
    Counter.inc(
      name: :http_check_total,
      labels: [target]
    )
  end

  @spec http_check_duration_microseconds(any) :: any
  def http_check_duration_microseconds(time) do
    Logger.info(time)
    Histogram.observe([name: :http_check_duration_milliseconds,
    labels: [:value]], time)
  end
end
