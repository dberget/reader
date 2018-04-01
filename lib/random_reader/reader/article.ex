defmodule RandomReader.Reader.Article do
  use Ecto.Schema

  schema "reader_articles" do
    field :title, :string
    
    belongs_to :user, RandomReader.Accounts.User
    timestamps()
  end
end
