defmodule Tictactoe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {NodeJS.Supervisor, [path: LiveSvelte.SSR.server_path(), pool_size: 4]},
      # Start the Telemetry supervisor
      TictactoeWeb.Telemetry,
      # Start the Ecto repository
      Tictactoe.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Tictactoe.PubSub},
      # Start Finch
      {Finch, name: Tictactoe.Finch},
      # Start the Endpoint (http/https)
      TictactoeWeb.Endpoint
      # Start a worker by calling: Tictactoe.Worker.start_link(arg)
      # {Tictactoe.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tictactoe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TictactoeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
