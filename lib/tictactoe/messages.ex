defmodule Tictactoe.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false

  alias Tictactoe.Matches.Message
  alias Tictactoe.Repo

  alias Phoenix.PubSub

  def send_message(%{match_id: match_id} = opts) do
    Message.changeset(%Message{}, opts)
    |> Repo.insert()
    |> notify(match_id, :sent_message)
  end

  def notify({:ok, %Message{} = message}, match_id, event) do
    PubSub.broadcast(Tictactoe.PubSub, "match:#{match_id}", {event, message})
  end

  def get_messages(match_id) do
    query =
      from m in Message,
        where: m.match_id == ^match_id,
        select: m

    Repo.all(query)
  end
end
