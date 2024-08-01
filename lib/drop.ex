defmodule Wonk.Drop do
  @keys ~w(text wiki_url ep airdate title)a
  @enforce_keys ~w(text wiki_url)a
  defstruct @keys

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
