defmodule RandomReader.Reader.GetArticle do
  @moduledoc """
    Retrieves and checks a title against the users read titles, then converts url page to html and sends in an email to user.
  """
  alias RandomReader.{Reader, Accounts, Mailer.Email, Repo, Reader.GetArticle}

  defstruct [:list, :user, :article_data, :blog_post, :title, :link, :error]

  def main(id, list) do
    %GetArticle{list: list, user: id}
    |> remove_user_articles()
    |> select_random_article()
    |> request_article()
    |> email_article()
    |> update_user()
    |> handle_errors()
  end

  defp remove_user_articles(%GetArticle{user: id, list: list} = article) do
    user_articles = Reader.user_articles(id)
    Enum.reject(list, &Enum.member?(user_articles, elem(&1, 1)))

    %GetArticle{article | list: list}
  end

  defp select_random_article(%GetArticle{list: list} = article) do
    random_article =
      list
      |> Enum.random()

    %GetArticle{
      article
      | list: list,
        title: elem(random_article, 0),
        link: elem(random_article, 1),
        article_data: random_article
    }
  end

  defp request_article(%GetArticle{link: link} = article) do
    case HTTPoison.get(link) do
      {:ok, blog_post} ->
        %GetArticle{article | blog_post: blog_post}

      {:error, _} ->
        %GetArticle{article | error: true}
    end
  end

  defp update_user(%GetArticle{error: true} = article), do: article

  defp update_user(%GetArticle{title: title, user: id} = article) do
    Repo.insert!(%Reader.Article{title: title, user_id: id})

    article
  end

  defp email_article(%GetArticle{error: true} = article), do: article

  defp email_article(%GetArticle{user: id, blog_post: blog_post, title: title} = article) do
    user = Accounts.get_user!(id)

    blog_post.body
    |> Readability.article()
    |> Readability.readable_html()
    |> Email.new_email(user.email, title)
    |> RandomReader.Mailer.deliver_now()

    article
  end

  defp handle_errors(%GetArticle{user: id, error: true}) do
    IO.puts("Error for User #{id}")
  end
  defp handle_errors(%GetArticle{} = article), do: article
end
