defmodule Tictactoe.Repo.Migrations.AddShortlinks do
  use Ecto.Migration

  def change do
    create table(:short_links) do
      add :code, :string, null: false
      add :match_id, :uuid, null: false

      timestamps()
    end

    create index(:short_links, [:code], unique: true)

    alter table(:matches) do
      add :short_link_id, references(:short_links, on_delete: :nothing)
    end
  end
end
