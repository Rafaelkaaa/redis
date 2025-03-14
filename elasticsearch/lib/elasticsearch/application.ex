defmodule Elasticsearch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElasticsearchWeb.Telemetry,
      Elasticsearch.Repo,
      {DNSCluster, query: Application.get_env(:elasticsearch, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Elasticsearch.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Elasticsearch.Finch},
      # Start a worker by calling: Elasticsearch.Worker.start_link(arg)
      # {Elasticsearch.Worker, arg},
      # Start to serve requests, typically the last entry
      ElasticsearchWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elasticsearch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElasticsearchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
