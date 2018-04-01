defmodule RandomReader.Accounts.User do
  use Ecto.Schema

  schema "accounts_users" do
    field(:email, :string)
    field(:complete, :boolean, default: false)

    has_many(:reader_articles, RandomReader.Reader.Article)
    timestamps()
  end
end
