defmodule RandomReader.Repo.Migrations.CreateRandomReader.Reader.Article do
  use Ecto.Migration

  def change do
    create table(:reader_articles) do
      add :title, :string
      add :user_id, references(:accounts_users, on_delete: :delete_all)

      timestamps()
    end
    create index(:reader_articles, [:user_id])
    create unique_index(:reader_articles, [:user_id, :title], name: "reader_articles_user_id_title_unique_index")
  end
end
