defmodule TictactoeWeb.BoardLive do
  use TictactoeWeb, :live_view
  alias Tictactoe.Matches

  def render(assigns) do
    ~H"""
    <.svelte name="GameBoard" props={%{match: @match, playerSymbol: @player_symbol}} socket={@socket} />
    """
  end

  def mount(%{"id" => id} = params, _session, socket) do
    if connected?(socket), do: Matches.subscribe(id)

    match = Matches.get_match!(id)
    guest? = Map.has_key?(params, "g")
    player_symbol =
      case guest? do
        :false -> "X"
        :true -> "O"
      end
    {:ok, assign(socket, match: match, player_symbol: player_symbol)}
  end

  def handle_event("make_move", %{"id" => id, "index" => index, "symbol" => symbol}, socket) do
    match = Matches.get_match!(id)
    Matches.make_move(match, index, symbol)
    {:noreply, socket}
  end

  def handle_event("guest_nickname_input", %{"id" => id, "nickname" => nickname}, socket) do
    match = Matches.get_match!(id)
    Matches.guest_nickname_input(match, nickname)
    {:noreply, socket}
  end

  def handle_event("put_flash", %{"type" => type, "message" => message}, socket) do
    {:noreply, put_flash(socket, String.to_atom(type), message)}
  end

  def handle_info({:made_move, match}, socket) do
    {:noreply, assign(socket, match: match)}
  end

  def handle_info({:put_flash, type, message}, socket) do
    {:noreply, put_flash(socket, type, message)}
  end
end
