defmodule Wonk.Scraper do
  use Crawly.Spider
  @first_ep "https://knowledge-fight.fandom.com/wiki/16:_February_24,_2017"

  @impl Crawly.Spider
  def override_settings do
    [
      middlewares: [
        Crawly.Middlewares.DomainFilter
      ],
      pipelines: [
        {Wonk.Scraper.DropParser},
        {Crawly.Pipelines.WriteToFile, extension: "txt", folder: "./static/crawls"}
      ]
    ]
  end

  @impl Crawly.Spider
  def base_url(), do: "https://knowledge-fight.fandom.com"

  @impl Crawly.Spider
  def init(), do: [start_urls: [@first_ep]]

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    drop =
      document
      |> Floki.find("[data-source=\"oocDrop\"] div")
      |> Floki.text()

    next =
      document
      |> Floki.find("[data-source=\"nextEpisode\"] a")
      |> Floki.attribute("href")
      # should only have one "next" link
      |> Enum.at(0)
      |> Crawly.Utils.build_absolute_url(response.request.url)
      |> Crawly.Utils.request_from_url()

    %Crawly.ParsedItem{items: [%{drop: drop}], requests: [next]}
  end
end
