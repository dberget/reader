defmodule RandomReader.Reader.ProcessList do
  def get_list do
    case HTTPoison.get("http://www.aaronsw.com/2002/feeds/pgessays.rss") do
      {:ok, feed} ->
        Quinn.parse(feed.body)
        |> format_list

      {:error, _} ->
        IO.puts("list request fail")
    end
  end

  defp format_list(list) do
    titles = Quinn.find(list, :title) |> Enum.map(&List.first(&1.value))
    links = Quinn.find(list, :link) |> Enum.map(&List.first(&1.value))

    Enum.zip(titles, links)
  end
end
