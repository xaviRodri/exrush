defmodule Exrush.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ExrushWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Exrush.PubSub},
      # Start the Endpoint (http/https)
      ExrushWeb.Endpoint,
      # Start the RushingReader to feed the data
      Exrush.RushingReader
      # Start a worker by calling: Exrush.Worker.start_link(arg)
      # {Exrush.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exrush.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExrushWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
