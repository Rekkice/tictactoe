defmodule Tictactoe.Matches.Message do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, except: [:__meta__]}

  schema "match_messages" do
    field :content, :string
    field :user, :string
    field :match_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user, :content, :match_id])
    |> validate_required([:user, :content])
  end
end
