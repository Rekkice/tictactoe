defmodule Tictactoe.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "matches" do
    field :game_status, :string, default: "waiting"
    field :guest_player, :string
    field :host_player, :string
    field :state, {:array, :string}
    field :turn, :string

    timestamps()
  end

  defp valid_state(contents) do
    case contents do
      [] -> []
      ["X" | tail] -> valid_state tail
      ["O" | tail] -> valid_state tail
      [" " | tail] -> valid_state tail
      _ -> [state: "state is invalid"]
    end
  end

  def validate_state(changeset) do
    validate_change(changeset, :state, fn _field, value ->
      valid_state value
    end)
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:turn, :state, :game_status, :host_player, :guest_player])
    |> validate_required([:turn, :state, :game_status, :host_player])
    |> validate_length(:host_player, min: 3)
    |> validate_length(:guest_player, min: 3)
    |> validate_length(:state, is: 9)
    |> validate_state
  end

  def change_state(match, state) do
    match
    |> force_change(:state, state)
  end
end
