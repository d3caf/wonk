defmodule Wonk.Scraper.DropParser do
  @behaviour Crawly.Pipeline

  @impl Crawly.Pipeline
  def run(%{drop: ""}, state), do: {false, state}
  def run(%{drop: drop}, state), do: {drop, state}
end
