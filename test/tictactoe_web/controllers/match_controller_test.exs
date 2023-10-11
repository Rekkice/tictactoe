defmodule TictactoeWeb.MatchControllerTest do
  use TictactoeWeb.ConnCase

  import Tictactoe.MatchesFixtures

  @create_attrs %{
    game_status: "ongoing",
    guest_player: "some guest_player",
    host_player: "some host_player",
    state: ["option1", "option2"],
    turn: "some turn"
  }
  @update_attrs %{
    game_status: "ongoing",
    guest_player: "some updated guest_player",
    host_player: "some updated host_player",
    state: ["option1"],
    turn: "some updated turn"
  }
  @invalid_attrs %{game_status: nil, guest_player: nil, host_player: nil, state: nil, turn: nil}

  describe "index" do
    test "lists all matches", %{conn: conn} do
      conn = get(conn, ~p"/match")
      assert html_response(conn, 200) =~ "Listing Matches"
    end
  end

  describe "new match" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/match/new")
      assert html_response(conn, 200) =~ "New Match"
    end
  end

  describe "create match" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/match", match: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/match/#{id}"

      conn = get(conn, ~p"/match/#{id}")
      assert html_response(conn, 200) =~ "Match #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/match", match: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Match"
    end
  end

  describe "edit match" do
    setup [:create_match]

    test "renders form for editing chosen match", %{conn: conn, match: match} do
      conn = get(conn, ~p"/match/#{match}/edit")
      assert html_response(conn, 200) =~ "Edit Match"
    end
  end

  describe "update match" do
    setup [:create_match]

    test "redirects when data is valid", %{conn: conn, match: match} do
      conn = put(conn, ~p"/match/#{match}", match: @update_attrs)
      assert redirected_to(conn) == ~p"/match/#{match}"

      conn = get(conn, ~p"/match/#{match}")
      assert html_response(conn, 200) =~ "some updated guest_player"
    end

    test "renders errors when data is invalid", %{conn: conn, match: match} do
      conn = put(conn, ~p"/match/#{match}", match: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Match"
    end
  end

  describe "delete match" do
    setup [:create_match]

    test "deletes chosen match", %{conn: conn, match: match} do
      conn = delete(conn, ~p"/match/#{match}")
      assert redirected_to(conn) == ~p"/match"

      assert_error_sent 404, fn ->
        get(conn, ~p"/match/#{match}")
      end
    end
  end

  defp create_match(_) do
    match = match_fixture()
    %{match: match}
  end
end
