defmodule RedisApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RedisAppWeb.Telemetry,
      # RedisApp.Repo,
      {DNSCluster, query: Application.get_env(:redis_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RedisApp.PubSub},
      {Finch, name: RedisApp.Finch},
      RedisAppWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: RedisApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RedisAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
