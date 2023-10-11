defmodule Tictactoe.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :turn, :string
      add :state, {:array, :string}
      add :finished, :boolean, default: false, null: false
      add :host_player, :string
      add :guest_player, :string

      timestamps()
    end
  end
end
