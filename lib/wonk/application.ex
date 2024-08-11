defmodule Wonk.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [{Bandit, plug: WonkWeb.Endpoint, scheme: :http}]

    opts = [strategy: :one_for_one, name: Wonk.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
