defmodule WonkWeb.Endpoint do
  require Logger

  def init(opts) do
    Logger.info("Starting WonkWeb")
    opts
  end

  def call(conn, _opts), do: WonkWeb.Router.call(conn, WonkWeb.Router.init([]))
end
