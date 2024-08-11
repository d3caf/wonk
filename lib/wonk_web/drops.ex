defmodule WonkWeb.Drops do
  require Logger
  alias Wonk.Drop

  @external_resource latest_scrape_file =
                       :code.priv_dir(:wonk)
                       |> Path.join("crawls/**/*.json")
                       |> Path.wildcard()
                       |> Enum.sort()
                       |> Enum.at(0)

  Logger.info("Latest scrape file: #{latest_scrape_file}")

  drops = Drop.parse_scrape!(latest_scrape_file)

  @drops drops |> Drop.filter_excluded_episodes()

  def render() do
    %{text: text, airdate: airdate, wiki_url: url} = random()

    """
    <div id="drop">
      <blockquote cite="#{url}">&ldquo;#{text}&rdquo;</blockquote>
      <p>&mdash; Alex Jones, <cite><a href="#{url}" target="_blank">#{airdate}</a></cite></p>
    </div>
    """
  end

  @spec random() :: Drop.t()
  defp random(), do: Enum.random(@drops)
end
