defmodule IsItUp.Metrics.Instrumenter do
  use Prometheus.Metric
  alias Prometheus.Metric.{Counter, Histogram, Gauge}
  require Logger

  @counter [
    name: :http_check_total,
    help: "counter incremeted for every http request upstream",
    labels: [:target]
  ]

  @histogram [
    name: :http_check_duration_microseconds,
    labels: [:target],
    buckets: :default,
    help: "Http check execution time"
  ]

  @gauge [
    name: :http_check_duration_gauge_microseconds,
    labels: [:target],
    help: "Http check execution time"
  ]

  @spec http_check(String.t()) :: any
  def http_check(target) do
    Counter.inc(
      name: :http_check_total,
      labels: [target]
    )
  end

  @spec http_check_duration_microseconds(integer(), String.t()) :: any
  def http_check_duration_microseconds(time, target) do
    Logger.info(time)

    Gauge.set(
      [name: :http_check_duration_gauge_microseconds,labels: [target]] ,
      time)

    Histogram.observe(
      [name: :http_check_duration_microseconds, labels: [target]],
      time
    )
  end
end
