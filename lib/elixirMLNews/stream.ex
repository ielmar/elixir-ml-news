defmodule ElixirMLNews.Stream do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def connect(pid) do
    GenServer.call(__MODULE__, {:connect, pid})
  end

  @impl true
  def init(_opts) do
    {:ok, :unused_state}
  end

  @impl true
  def handle_call({:connect, from}, _from, _unused_state) do
    schedule_stream(from)
    headlines = ElixirMLNews.API.top_headlines()

    {:reply, Enum.take_random(headlines, 3), :unused_state}
  end

  @impl true
  def handle_info({:stream, pid}, _unused_state) do
    schedule_stream(pid)

    headlines = ElixirMLNews.API.top_headlines()
    send(pid, {:stream, Enum.take_random(headlines, 3)})

    {:noreply, :unused_state}
  end

  defp schedule_stream(pid) do
    # Send news articles to pid at a random interval
    rand_minutes = :rand.uniform(10) * 1000 * 60
    Process.send_after(self(), {:stream, pid}, rand_minutes)
  end
end
