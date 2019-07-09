defmodule IsItUp.Checker do
  require Logger

  alias IsItUp.Metrics.Instrumenter

  defstruct last_check: nil, status: nil
  @type t :: %__MODULE__{last_check: String.t(), status: non_neg_integer}

  use GenServer
  use Timex

  defp check_init_delay() do
    Application.get_env(:is_it_up, :check_init_delay) * 1000
  end

  defp check_interval() do
    Application.get_env(:is_it_up, :check_interval) * 1000
  end

  defp check_host() do
    Application.get_env(:is_it_up, :check_host)
  end

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(arg) do
    IO.puts("start_link #{inspect(arg)}")
    start_link()
  end

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__)
  end

  @spec init(__MODULE__.t()) :: {:ok, __MODULE__.t()}
  def init(state) do
    IO.puts("init")
    Process.send_after(self(), :do_check, check_init_delay())
    {:ok, state}
  end

  @spec is_it_up :: {:ok, true} | {:ok, false}
  def is_it_up() do
    IO.inspect(:is_it_up)
    GenServer.call(__MODULE__, :is_it_up, 50)
  end

  @spec handle_call(:is_it_up, any, any) :: {:reply, {:ok, boolean()}, any}
  def handle_call(:is_it_up, _from, state) do
    Logger.debug(inspect(state))

    case state do
      %__MODULE__{status: 200} -> {:reply, {:ok, true}, state}
      %__MODULE__{status: 301} -> {:reply, {:ok, true}, state}
      _ -> {:reply, {:ok, false}, state}
    end
  end

  def handle_info(:do_check, _state) do
    Process.send_after(self(), :do_check, check_interval())
    host = "http://#{check_host()}"
    Instrumenter.http_check(host)
    status = check_host(host)
    {:noreply, %__MODULE__{last_check: get_now(), status: status}}
  end

  def check_host(host) do
    fn_check = fn ->
      {time, %{status_code: x}} = :timer.tc(&HTTPoison.head!/1, [host])
      Instrumenter.http_check_duration_microseconds(time, host)
      x
    end

    t = Task.async(fn_check)
    Task.await(t)
  end

  defp get_now() do
    date = Timex.now()
    Timex.format!(date, "{ISO:Extended}")
  end
end
