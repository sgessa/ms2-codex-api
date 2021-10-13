defmodule Codex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    CodexWeb.Endpoint.rm_socket()

    children = [
      # Start the Ecto repository
      Codex.Repo,
      # Start the Telemetry supervisor
      CodexWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Codex.PubSub},
      # Start the Endpoint (http/https)
      CodexWeb.Endpoint,
      # Startup Worker
      Supervisor.child_spec(Codex.StartupWorker, restart: :temporary)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Codex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CodexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
