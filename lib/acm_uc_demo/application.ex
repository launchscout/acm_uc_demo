defmodule AcmUcDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AcmUcDemoWeb.Telemetry,
      AcmUcDemo.Repo,
      {DNSCluster, query: Application.get_env(:acm_uc_demo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AcmUcDemo.PubSub},
      # Start a worker by calling: AcmUcDemo.Worker.start_link(arg)
      # {AcmUcDemo.Worker, arg},
      # Start to serve requests, typically the last entry
      AcmUcDemoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AcmUcDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AcmUcDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
