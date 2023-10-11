defmodule Tictactoe.MatchesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tictactoe.Matches` context.
  """

  @doc """
  Generate a match.
  """
  def match_fixture(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(%{
        game_status: "ongoing",
        guest_player: "some guest_player",
        host_player: "some host_player",
        state: ["option1", "option2"],
        turn: "some turn"
      })
      |> Tictactoe.Matches.create_match()

    match
  end
end
