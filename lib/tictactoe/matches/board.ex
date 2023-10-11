defmodule Tictactoe.Matches.Board do

  @symbols ["X", "O"]

  def full?(state) do
    Enum.all?(state, & &1 != " ")
  end

  def get_status(state) do
    case do_winner(state) do
      s when s in @symbols -> "#{s}_won"
      _ ->
        if full?(state) do
          :draw
        else
          :ongoing
        end
    end
  end

  defp do_winner([
    s, s, s,
    _, _, _,
    _, _, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, _,
    s, s, s,
    _, _, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, _,
    _, _, _,
    s, s, s
  ]) when s in @symbols, do: s


  defp do_winner([
    s, _, _,
    s, _, _,
    s, _, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, s, _,
    _, s, _,
    _, s, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, s,
    _, _, s,
    _, _, s
  ]) when s in @symbols, do: s


  defp do_winner([
    s, _, _,
    _, s, _,
    _, _, s
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, s,
    _, s, _,
    s, _, _
  ]) when s in @symbols, do: s

  defp do_winner(_), do: nil
end
