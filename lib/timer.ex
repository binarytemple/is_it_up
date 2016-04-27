defmodule HelloWorld.Timer do
  use GenServer

  @time_30_sec "30 * 1000"
  @time_10_sec "10 * 1000"

  def start_link do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  defp eval(time) do
    List.first Tuple.to_list Code.eval_string(time)
  end

  def init(state) do
    Process.send_after(self(), :work, eval(@time_10_sec))
    {:ok, state}
  end

  def is_it_up() do
    GenServer.call( __MODULE__, :is_it_up,50)
  end

  def handle_call(:is_it_up, _from, state) do
    case state do
      %{status: :up} -> { :reply, { :ok, :up}, state }
      %{status: :bad_status} -> { :reply, { :ok, :bad_status}, state }
      _ ->  { :reply, { :ok, :unknown}, state }
    end
  end

  def handle_info(:work, state) do
    # Start the timer again
    Process.send_after(self(), :work, eval(@time_30_sec))

    status = case HTTPoison.head! "http://binarytemple.co.uk" do
      %{status_code: 200 } -> :up
      _ -> :bad_status
    end

    IO.puts "Checked server status - #{inspect  :calendar.now_to_datetime(:erlang.timestamp) } - status is #{status}"

    {:noreply, Map.put(state, :status, status) }
  end
end
