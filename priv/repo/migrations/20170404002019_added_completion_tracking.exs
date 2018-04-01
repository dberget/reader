defmodule RandomReader.Repo.Migrations.AddedCompletionTracking do
  use Ecto.Migration

  def change do
    alter table(:accounts_users) do
      add :complete, :boolean, default: 0
    end
  end
end
