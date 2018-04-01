defmodule RandomReader.Reader.GetArticle do
  @moduledoc """
    Retrieves and checks a title against the users read titles, then converts url page to html and sends in an email to user.
  """
  alias RandomReader.{Reader, Accounts, Mailer.Email, Repo, Reader.GetArticle}

  defstruct [:list, :user, :article_data, :blog_post, :title, :link, :error]

  def start_feed(id) do
    {:ok, feed} = HTTPoison.get("http://www.aaronsw.com/2002/feeds/pgessays.rss")

    list =
      Quinn.parse(feed.body)
      |> remove_user_articles(id)

    main(id, list)
  end

  def main(id, list) do
    %GetArticle{list: list, user: id}
    |> select_random_article()
    |> request_article()
    |> email_article()
    |> update_user()
  end

  defp remove_user_articles(blog_list, id) do
    user_articles = Reader.user_articles(id)

    blog_list -- user_articles
  end

  def select_random_article(%GetArticle{list: list} = article) do
    random_article =
      list
      |> Quinn.find(:item)
      |> Enum.random()

    %GetArticle{
      article
      | list: list,
        title: obj_to_string(random_article, :title),
        link: obj_to_string(random_article, :link),
        article_data: random_article
    }
  end

  defp request_article(%GetArticle{link: link} = article) do
    case HTTPoison.get(link) do
      {:ok, blog_post} ->
        %GetArticle{article | blog_post: blog_post}

      {:error, error} ->
        %GetArticle{article | error: error}
    end
  end

  defp obj_to_string(item, type) do
    obj =
      Quinn.find(item, type)
      |> List.first()

    List.first(obj.value)
  end

  defp update_user(%GetArticle{title: title, user: id}) do
    Repo.insert!(%Reader.Article{title: title, user_id: id})
  end

  defp email_article(%GetArticle{user: id, blog_post: blog_post, title: title} = article) do
    user = Accounts.get_user!(id)

    body =
      blog_post.body
      |> Readability.article()
      |> Readability.readable_html()

    Email.new_email(body, user.email, title) |> RandomReader.Mailer.deliver_now()

    article
  end
end
