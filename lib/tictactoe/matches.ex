defmodule Tictactoe.Matches do
  @moduledoc """
  The Matches context.
  """

  import Ecto.Query, warn: false
  alias Tictactoe.Repo
  alias Phoenix.PubSub

  alias Tictactoe.Matches.Match
  alias Tictactoe.Matches.Board
  alias Tictactoe.ShortLinks

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """
  def list_matches do
    Repo.all(Match)
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id), do: Repo.get!(Match, id) |> Repo.preload(:short_link_id)

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{
      state: [" ", " ", " ", " ", " ", " ", " ", " ", " "],
      game_status: "waiting_join",
      turn: "X"
    }
    |> Match.changeset(attrs |> Map.delete(:state) |> Map.delete(:turn))
    |> Repo.insert()
    |> ShortLinks.create_short_link()
    # update match with created short link
  end

  @doc """
  Updates a match.

  ## Examples

      iex> update_match(match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(match)
      %Ecto.Changeset{data: %Match{}}

  """
  def change_match(%Match{} = match, attrs \\ %{}) do
    Match.changeset(match, attrs)
  end

  def make_move(
        %Match{state: old_state, turn: turn, game_status: old_status} = match,
        index,
        symbol
      ) do
    valid_move = Enum.at(old_state, index) == " " && turn == symbol && old_status == "ongoing"

    if valid_move do
      new_state = List.replace_at(old_state, index, symbol)

      new_symbol =
        case symbol do
          "X" -> "O"
          "O" -> "X"
        end

      new_status = to_string(Board.get_status(new_state))

      match
      |> Match.changeset(%{turn: new_symbol, game_status: new_status})
      |> Match.change_state(new_state)
      |> Repo.update()
      |> notify(:made_move)
    end
  end

  def guest_nickname_input(match, nickname) do
    match
    |> Match.changeset(%{guest_player: nickname, game_status: "ongoing"})
    |> Repo.update()
    |> notify(:made_move)
  end

  def subscribe(id) do
    PubSub.subscribe(Tictactoe.PubSub, "match:#{id}")
  end

  def notify({:ok, %Match{:id => id} = match}, event) do
    PubSub.broadcast(Tictactoe.PubSub, "match:#{id}", {event, match})
  end

  def notify({:error, reason}, _event), do: {:error, reason}
end
