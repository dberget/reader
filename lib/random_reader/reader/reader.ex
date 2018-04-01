defmodule RandomReader.Reader do
  @moduledoc """
  The boundary for the Readincompletesystem.
  """
  import Ecto.{Query, Changeset}, warn: false
  alias RandomReader.Repo
  alias RandomReader.Reader.Article

  def list_articles do
    Repo.all(Article)
  end

  def user_articles(user_id) do
    query = from(a in "reader_articles", where: a.user_id == ^user_id, select: a.title)
    Repo.all(query)
  end

  def get_article!(id), do: Repo.get!(Article, id)

  def create_article(attrs \\ %{}) do
    %Article{}
    |> article_changeset(attrs)
    |> Repo.insert()
  end

  def update_article(%Article{} = article, attrs) do
    article
    |> article_changeset(attrs)
    |> Repo.update()
  end

  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  def change_article(%Article{} = article) do
    article_changeset(article, %{})
  end

  defp article_changeset(%Article{} = article, attrs) do
    article
    |> cast(attrs, [])
    |> validate_required([:title, :user_id])
    |> unique_constraint(:user_id, name: "read_article_user_id_article_id_unique_index")
    |> cast_assoc(:user)
  end
end
