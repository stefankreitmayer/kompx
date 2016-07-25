defmodule Kompax.Moekdown do
  def html(body) do
    String.split(body, "\n")
    |> List.foldl("", fn(line,html) -> html<>line2html(line) end)
  end

  defp line2html(line) do
    cond do
      line =~ ~r/\A\*\*/ ->
        tail = String.replace_leading(line, "*","")
        "<ul style='margin-left: 14px; list-style-type:circle'><li>#{tail}</li></ul>"
      line =~ ~r/\A\*/ ->
        tail = String.replace_prefix(line, "*","")
        "<ul style='margin-left: -8px; list-style-type:square'><li>#{tail}</li></ul>"
      true ->
        "<p>#{line}</p>"
    end
  end
end
