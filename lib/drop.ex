defmodule Wonk.Drop do
  @keys ~w(text wiki_url ep airdate title)a
  @enforce_keys ~w(text wiki_url)a
  defstruct @keys

  @excluded_episodes [
    156,
    153,
    125,
    87,
    79,
    362,
    353,
    351,
    332,
    280,
    263,
    260,
    232,
    229,
    223,
    207,
    499,
    452,
    411,
    595
  ]

  @type t() :: %__MODULE__{
          text: String.t(),
          wiki_url: String.t(),
          ep: String.t(),
          airdate: String.t(),
          title: String.t()
        }

  def parse_scrape!(scrape_file_path) do
    File.stream!(scrape_file_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&Jason.decode!(&1, keys: :atoms!))
    |> Stream.map(&struct!(__MODULE__, &1))
    |> Enum.to_list()
  end

  def filter_excluded_episodes(drops) do
    Enum.reject(drops, fn %{ep: ep} ->
      String.to_integer(ep) in @excluded_episodes
    end)
  end

  def from_wiki_response(response) do
    {:ok, document} = Floki.parse_document(response.body)

    %__MODULE__{
      title: title(document),
      text: value_in_infobox(document, "oocDrop"),
      ep: value_in_infobox(document, "episodeNumber"),
      airdate: value_in_infobox(document, "airDate"),
      wiki_url: response.request.url
    }
  end

  def keys(), do: @keys

  defp title(document),
    do:
      document
      |> Floki.find(~s([data-source="title"]))
      |> Floki.text()

  defp value_in_infobox(document, field),
    do:
      document
      |> Floki.find(~s([data-source="#{field}"] div))
      |> Floki.text()
end
