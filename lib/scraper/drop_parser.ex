defmodule Wonk.Scraper.DropParser do
  @behaviour Crawly.Pipeline

  alias Wonk.Drop

  @impl Crawly.Pipeline
  def run(%Drop{text: ""}, state), do: {false, state}
  def run(drop, state), do: {drop, state}
end
