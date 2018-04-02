defmodule RandomReader.Reader.ArticleRetriever do
  @moduledoc """
    Retrieves and checks a title against the users read titles, then converts url page to html and sends in an email to user.
  """
  alias RandomReader.{Reader, Accounts, Mailer.Email, Repo, Reader.ArticleRetriever}

  defstruct [:list, :user, :article_data, :blog_post, :title, :link, :error]

  def get_article(id, list) do
    %ArticleRetriever{list: list, user: id}
    |> remove_user_articles()
    |> select_random_article()
    |> request_article()
    |> email_article()
    |> update_user()
    |> handle_errors()
  end

  defp remove_user_articles(%ArticleRetriever{user: id, list: list} = article) do
    user_articles = Reader.user_articles(id)
    new_list = Enum.reject(list, &Enum.member?(user_articles, elem(&1, 0)))

    %ArticleRetriever{article | list: new_list}
  end

  defp select_random_article(%ArticleRetriever{list: list} = article) do
    random_article =
      list
      |> Enum.random()

    %ArticleRetriever{
      article
      | list: list,
        title: elem(random_article, 0),
        link: elem(random_article, 1),
        article_data: random_article
    }
  end

  defp request_article(%ArticleRetriever{link: link} = article) do
    case HTTPoison.get(link) do
      {:ok, blog_post} ->
        %ArticleRetriever{article | blog_post: blog_post}

      {:error, _} ->
        %ArticleRetriever{article | error: true}
    end
  end

  defp update_user(%ArticleRetriever{error: true} = article), do: article

  defp update_user(%ArticleRetriever{title: title, user: id} = article) do
    Repo.insert!(%Reader.Article{title: title, user_id: id})

    article
  end

  defp email_article(%ArticleRetriever{error: true} = article), do: article

  defp email_article(%ArticleRetriever{user: id, blog_post: blog_post, title: title} = article) do
    user = Accounts.get_user!(id)

    blog_post.body
    |> Readability.article()
    |> Readability.readable_html()
    |> Email.new_email(user.email, title)
    |> RandomReader.Mailer.deliver_now()

    article
  end

  defp handle_errors(%ArticleRetriever{user: id, error: true}) do
    IO.puts("Error for User #{id}")
  end

  defp handle_errors(%ArticleRetriever{error: _} = article), do: article
end
