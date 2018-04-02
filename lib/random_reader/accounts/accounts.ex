defmodule RandomReader.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias RandomReader.Repo

  alias RandomReader.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def all_users() do
    query = from(u in User, select: u.id)
    Repo.all(query)
  end

  def preload_articles(user) do
    user
    |> Repo.preload(:reader_articles)
  end

  def all_incomplete_users() do
    query = from(u in "accounts_users", where: u.complete == 0, select: u.*)
    Repo.all(query)
  end

  def user_titles_count(user_id) do
    query = from(u in "reader_articles", where: u.user_id == ^user_id, select: count(u.title))
    Repo.all(query)
  end

  def check_if_user_complete(user_id) do
    user_title_count = Accounts.user_titles_count(user_id) |> List.first()

  # if user_title_count >= master_article_count, do: mark_complete(user_id)
  end

  def mark_complete(user_id) do
    user = get_user!(user_id)

    update_user(user, %{complete: true})
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> user_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :complete])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
end
