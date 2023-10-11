defmodule Tictactoe.MatchesTest do
  use Tictactoe.DataCase

  alias Tictactoe.Matches

  describe "matches" do
    alias Tictactoe.Matches.Match

    import Tictactoe.MatchesFixtures

    @invalid_attrs %{game_status: "ongoing", guest_player: nil, host_player: nil, state: nil, turn: nil}

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Matches.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Matches.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      valid_attrs = %{
        game_status: "ongoing",
        guest_player: "some guest_player",
        host_player: "some host_player",
        state: ["option1", "option2"],
        turn: "some turn"
      }

      assert {:ok, %Match{} = match} = Matches.create_match(valid_attrs)
      assert match.game_status == "ongoing"
      assert match.guest_player == "some guest_player"
      assert match.host_player == "some host_player"
      assert match.state == ["option1", "option2"]
      assert match.turn == "some turn"
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matches.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()

      update_attrs = %{
        game_status: "ongoing",
        guest_player: "some updated guest_player",
        host_player: "some updated host_player",
        state: ["option1"],
        turn: "some updated turn"
      }

      assert {:ok, %Match{} = match} = Matches.update_match(match, update_attrs)
      assert match.game_status == false
      assert match.guest_player == "some updated guest_player"
      assert match.host_player == "some updated host_player"
      assert match.state == ["option1"]
      assert match.turn == "some updated turn"
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Matches.update_match(match, @invalid_attrs)
      assert match == Matches.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Matches.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Matches.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Matches.change_match(match)
    end
  end
end
