defmodule Tictactoe.Repo.Migrations.AddIndexToMessage do
  use Ecto.Migration

  def change do
    create index(:match_messages, [:match_id])
  end
end
