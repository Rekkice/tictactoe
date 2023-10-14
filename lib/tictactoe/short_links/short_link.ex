defmodule Tictactoe.ShortLinks.ShortLink do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, except: [:__meta__]}

  schema "short_links" do
    field :code, :string
    field :match_id, :binary_id

    timestamps()
  end

  def changeset(short_link, attrs) do
    short_link
    |> cast(attrs, [:code, :match_id])
    |> validate_required([:code, :match_id])
  end

end
