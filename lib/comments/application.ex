defmodule Comments.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CommentsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Comments.PubSub},
      # Start the Endpoint (http/https)
      CommentsWeb.Endpoint
      # Start a worker by calling: Comments.Worker.start_link(arg)
      # {Comments.Worker, arg}
    ]

    IO.puts("IN START")
    :ets.new(:comments, [:named_table, :bag, :public])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Comments.Supervisor]

    # Could check for this earlier, but simple to just put here
    case System.get_env("NYT_API_KEY") do
      val when val == nil or val == "" ->
        {:error, "NYT_API_KEY not set"}

      _ ->
        Supervisor.start_link(children, opts)
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CommentsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
