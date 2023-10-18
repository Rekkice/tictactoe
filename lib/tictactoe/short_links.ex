defmodule Tictactoe.ShortLinks do
  @moduledoc """
  The Short Links context.
  """

  import Ecto.Query, warn: false
  alias Tictactoe.Matches
  alias Tictactoe.ShortLinks.ShortLink
  alias Tictactoe.Repo

  def get_match(code) do
    case Repo.get_by(ShortLink, code: code) do
      %ShortLink{} = short_link ->
        match = Matches.get_match!(short_link.match_id)
        {:ok, match}

      nil ->
        {:error, "ShortLink not found"}
    end
  end

  def destroy(conn, code) do
    case Repo.get_by(ShortLink, code: code) do
      %ShortLink{} = short_link ->
        Repo.delete(short_link)
        conn

      _ ->
        conn
    end
  end

  def create_short_link({:ok, match} = params) do
    short_link = %ShortLink{
      code: generate_code(),
      match_id: match.id
    }
    |> ShortLink.changeset(%{code: generate_code(), match_id: match.id})
    |> Repo.insert()

    Matches.get_match!(match.id)
    |> Matches.change_match(%{id_short_link: short_link})
    |> Repo.update!()

    params
  rescue
    Ecto.ConstraintError ->
      create_short_link(params)
  end

  def create_short_link({:error, message}) do
    {:error, message}
  end

  defp generate_code() do
    :crypto.strong_rand_bytes(5)
    |> Base.url_encode64()
    |> String.replace(~r/[-_\=]/, "")
    |> binary_part(0, 5)
  end
end
