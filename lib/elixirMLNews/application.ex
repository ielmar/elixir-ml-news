defmodule ElixirMLNews.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ElixirMLNewsWeb.Telemetry,
      # Start the Ecto repository
      ElixirMLNews.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirMLNews.PubSub},
      # Start Finch
      {Finch, name: ElixirMLNews.Finch},
      # Start the Endpoint (http/https)
      ElixirMLNewsWeb.Endpoint
      # Start a worker by calling: ElixirMLNews.Worker.start_link(arg)
      # {ElixirMLNews.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirMLNews.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirMLNewsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
