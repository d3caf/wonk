defmodule WonkWeb.Router do
  import WonkWeb.HTML, only: [render: 1]
  import Plug.Conn
  use Plug.Router

  plug(Plug.Static,
    at: "/static",
    from: :wonk
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> send_resp(
      200,
      render(WonkWeb.Drops.render())
    )
  end

  match _ do
    conn
    |> send_resp(404, "Not found")
  end
end
