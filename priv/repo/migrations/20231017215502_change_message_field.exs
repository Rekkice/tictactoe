defmodule Tictactoe.Repo.Migrations.ChangeMessageField do
  use Ecto.Migration

  def change do
    alter table(:match_messages) do
      remove :match
      add :match_id, :uuid, null: false
    end
  end
end
