defmodule RandomReader.Schedule do
  alias RandomReader.Accounts
  alias RandomReader.Reader.GetArticle
  use GenServer

  @moduledoc """
  """
  # Client

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  # Server Callback

  def handle_info(:work, state) do
    Accounts.all_incomplete_users()
    |> Task.async_stream(Accounts, :check_complete, [], [])

    Accounts.all_incomplete_users()
    |> Task.async_stream(GetArticle, :start_feed, [], [])
    |> Enum.to_list()

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work() do
    # Process.send_after(self(), :work, 8000) # 24 hours 86400000
  end
end
