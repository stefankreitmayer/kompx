defmodule Kompax.KindaMarkdownTest do
  use ExUnit.Case, async: true

  alias Kompax.KindaMarkdown

  describe "to_html" do
    test "parses heading h1" do
      assert KindaMarkdown.to_html("#Hello") == "<h1>Hello</h1>"
    end

    test "parses heading h2" do
      assert KindaMarkdown.to_html("##Hello") == "<h2>Hello</h2>"
    end

    test "parses heading h3" do
      assert KindaMarkdown.to_html("###Hello") == "<h3>Hello</h3>"
    end

    test "ignores empty lines" do
      assert KindaMarkdown.to_html("\n") == ""
    end

    test "parses images" do
      assert KindaMarkdown.to_html("http://example.com/cat.jpg") == "<img src='http://example.com/cat.jpg'>"
    end

    test "wraps normal lines in paragraphs" do
      assert KindaMarkdown.to_html("Hello\nWorld!") == "<p>Hello</p><p>World!</p>"
    end
  end
end
