defmodule TictactoeWeb.ShortLinkController do
  use TictactoeWeb, :controller

  alias Tictactoe.ShortLinks

  def show(conn, %{"code" => code}) do
    case ShortLinks.get_match(code) do
      {:ok, match} ->
        conn
        |> put_session("match:#{match.id}", %{role: "guest"})
        |> ShortLinks.destroy(code)
        |> redirect(to: "/match/#{match.id}")
      {:error, _} ->
        conn
        |> put_flash(:error, "Match not found")
        |> redirect(to: "/")
    end
  end

end
