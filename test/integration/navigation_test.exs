defmodule NavigationTest do
  use Kompax.IntegrationCase

  test "Home page" do
    navigate_to "/"
    page_source
    |> String.contains?("Willkommen")
    |> assert("Expected welcome text.")
  end

  test "Finder page from navbar" do
    navigate_to "/"
    link = find_element(:link_text, "Aufgaben")
    click(link)
    page_source
    |> String.contains?("Elm.Main.fullscreen()")
    |> assert("Expected Elm.")
  end

  test "Finder page from call to action" do
    navigate_to "/"
    link = find_element(:link_text, "Zu meinem Unterricht passende Aufgaben finden")
    click(link)
    page_source
    |> String.contains?("Elm.Main.fullscreen()")
    |> assert("Expected Elm.")
  end
end
