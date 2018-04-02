defmodule RandomReader.Schedule do
  alias RandomReader.Accounts
  alias RandomReader.Reader.{ArticleRetriever, ListRetriever}
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
    list_task = Task.async(fn -> ListRetriever.get_list() end)
    list = Task.await(list_task)

    perform_work(list)
    schedule_work()

    {:noreply, state}
  end

  defp perform_work(list) do
    Accounts.all_incomplete_users()
    |> Task.async_stream(ArticleRetriever, :get_article, [list], [])
    |> Enum.to_list()
  end

  defp schedule_work() do
    # 24 hours 86400000
    # Process.send_after(self(), :work, 8000)
  end
end
