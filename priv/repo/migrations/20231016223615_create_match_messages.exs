defmodule Tictactoe.Repo.Migrations.CreateMatchMessages do
  use Ecto.Migration

  def change do
    create table(:match_messages) do
      add :user, :string, null: false
      add :content, :string, null: false
      add :match, references(:matches, name: :id, type: :uuid, on_delete: :delete_all)

      timestamps()
    end
  end
end
