defmodule Tictactoe.Repo.Migrations.ChangeMatchesStatus do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :game_status, :string, default: "ongoing", null: false
      remove :finished
    end
  end
end
