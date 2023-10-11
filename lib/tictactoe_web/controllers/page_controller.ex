defmodule TictactoeWeb.PageController do
  use TictactoeWeb, :controller

  alias Tictactoe.Matches

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    changeset = Matches.change_match(%Matches.Match{})
    render(conn, :home, layout: false, changeset: changeset)
  end
end
