defmodule Kompax.KindaMarkdown do

  def to_html(markdown) do
    String.split(markdown, "\n")
    |> List.foldl("", fn(line,html) -> html<>line2html(line) end)
  end

  defp line2html(line) do
    line = Regex.replace(~r/\[(.+)\]\((.+)\)/, line, "<a href='\\2'>\\1</a>")
    cond do
      line =~ ~r/\A###/ ->
        tail = String.replace_leading(line, "#","")
        "<h3>#{tail}</h3>"
      line =~ ~r/\A##/ ->
        tail = String.replace_leading(line, "#","")
        "<h2>#{tail}</h2>"
      line =~ ~r/\A#/ ->
        tail = String.replace_leading(line, "#","")
        "<h1>#{tail}</h1>"
      line =~ ~r/\A\s*\z/ ->
        ""
      line =~ ~r/^http.*(jpg|jpeg|png)/i ->
        "<img src='#{line}'>"
      true ->
        "<p>#{line}</p>"
    end
  end
end
