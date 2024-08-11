defmodule Wonk.Scraper do
  use Crawly.Spider
  alias Wonk.Drop

  @ep_index "https://knowledge-fight.fandom.com/wiki/Category:Episodes"

  @impl Crawly.Spider
  def override_settings do
    [
      concurrent_requests_per_domain: 8,
      middlewares: [
        Crawly.Middlewares.DomainFilter
      ],
      pipelines: [
        {Wonk.Scraper.DropParser},
        {Crawly.Pipelines.JSONEncoder},
        {Crawly.Pipelines.WriteToFile, extension: "json", folder: "./static/crawls"}
      ]
    ]
  end

  @impl Crawly.Spider
  def base_url(), do: "https://knowledge-fight.fandom.com"

  @impl Crawly.Spider
  def init(), do: [start_urls: [@ep_index]]

  @impl Crawly.Spider
  def parse_item(%{request_url: @ep_index <> _rest} = response) do
    {:ok, document} = Floki.parse_document(response.body)

    episode_links =
      document
      |> Floki.find("li.category-page__member a")
      |> Enum.filter(&is_episode?/1)
      |> Enum.map(&href_from_link/1)
      |> Crawly.Utils.build_absolute_urls(response.request.url)
      |> Crawly.Utils.requests_from_urls()

    next_page =
      document
      |> Floki.find("a.category-page__pagination-next")
      |> Floki.attribute("href")
      |> Enum.at(0)

    %Crawly.ParsedItem{
      items: [],
      requests:
        if(next_page,
          do: [Crawly.Utils.request_from_url(next_page) | episode_links],
          else: episode_links
        )
    }
  end

  def parse_item(response) do
    %Crawly.ParsedItem{
      items: [
        Drop.from_wiki_response(response)
      ],
      requests: []
    }
  end

  defp is_episode?({"a", _attrs, [contents | _]}) when is_binary(contents),
    do: String.match?(contents, ~r|^(\d+:)|)

  defp is_episode?(_), do: false

  defp href_from_link({"a", [{"href", href} | _], _text}), do: href
end
