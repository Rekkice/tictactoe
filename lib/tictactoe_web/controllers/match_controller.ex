defmodule TictactoeWeb.MatchController do
  use TictactoeWeb, :controller

  alias Tictactoe.Matches

  def index(conn, _params) do
    matches = Matches.list_matches()
    render(conn, :index, matches: matches)
  end

  def create(conn, %{"host_player" => host_player}) do
    case Matches.create_match(%{"host_player" => host_player}) do
      {:ok, match} ->
        conn
        |> put_flash(:info, "Match created successfully.")
        |> redirect(to: ~p"/match/#{match}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    match = Matches.get_match!(id)
    render(conn, :show, match: match)
  end

  def edit(conn, %{"id" => id}) do
    match = Matches.get_match!(id)
    changeset = Matches.change_match(match)
    render(conn, :edit, match: match, changeset: changeset)
  end

  def update(conn, %{"id" => id, "match" => match_params}) do
    match = Matches.get_match!(id)

    case Matches.update_match(match, match_params) do
      {:ok, match} ->
        conn
        |> put_flash(:info, "Match updated successfully.")
        |> redirect(to: ~p"/match/#{match}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, match: match, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    match = Matches.get_match!(id)
    {:ok, _match} = Matches.delete_match(match)

    conn
    |> put_flash(:info, "Match deleted successfully.")
    |> redirect(to: ~p"/match")
  end
end
