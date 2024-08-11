defmodule WonkWeb.HTML do
  def render(content) do
    """
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>InfoWeird – Alex Jones quotes</title>

      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Ultra&display=swap" rel="stylesheet">
      <link href="/static/style.css" rel="stylesheet">
    </head>
    <body>
      <div id="background"></div>
      #{content}
    <footer>
      <p>Not affiliated with
        <a href="https://knowledgefight.com/" target="_blank">Knowledge
    Fight</a> (but you should be)
        or Infowars (thank god)
      </p>
    </footer>
    </body>
    </html>
    """
  end
end
