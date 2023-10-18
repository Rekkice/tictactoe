defmodule TictactoeWeb.BoardLive do
  use TictactoeWeb, :live_view
  alias Tictactoe.Matches
  alias Tictactoe.Messages

  def render(assigns) do
    ~H"""
    <.svelte
      name="GameBoard"
      props={%{match: @match, playerSymbol: @player_symbol, role: @role, initialMessages: @init_messages}}
      socket={@socket}
    />
    """
  end

  def mount(%{"id" => id} = _params, session, socket) do
    if connected?(socket), do: Matches.subscribe(id)

    match = Matches.get_match!(id)
    match_key = "match:#{match.id}"

    role =
      if Map.has_key?(session, match_key) do
        session
        |> Map.get(match_key)
        |> Map.get(:role)
      else
        "spectator"
      end

    player_symbol =
      case role do
        "host" -> "X"
        "guest" -> "O"
        _ -> nil
      end

    messages = Messages.get_messages(id)

    {:ok, assign(socket, match: match, player_symbol: player_symbol, role: role, init_messages: messages)}
  end

  def handle_event("make_move", %{"id" => id, "index" => index, "symbol" => symbol}, socket) do
    match = Matches.get_match!(id)
    Matches.make_move(match, index, symbol)
    {:noreply, socket}
  end

  def handle_event("send_message", %{"content" => content}, socket) do
    assigns = socket |> Map.get(:assigns)
    role =
      assigns
      |> Map.get(:role)

    match =
      assigns
      |> Map.get(:match)

    case role do
      "host" ->
        Messages.send_message(%{match_id: match.id, user: match.host_player, content: content})

      "guest" ->
        Messages.send_message(%{match_id: match.id, user: match.guest_player, content: content})

      _ ->
        {:noreply, socket}
    end

    {:noreply, socket}
  end

  def handle_event("guest_nickname_input", %{"id" => id, "nickname" => nickname}, socket) do
    role =
      socket
      |> Map.get(:assigns)
      |> Map.get(:role)

    if role == "guest" do
      match = Matches.get_match!(id)
      Matches.guest_nickname_input(match, nickname)
      {:noreply, socket}
    else
      {:noreply, put_flash(socket, :error, "You don't have the permission to join this match")}
    end
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

  def handle_info({:sent_message, message}, socket) do
    {:noreply, push_event(socket, "received_message", %{message: message})}
  end
end
