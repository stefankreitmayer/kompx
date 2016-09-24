defmodule NavigationTest do
  use Kompax.IntegrationCase

  test "Home page" do
    navigate_to "/"
    assert page_title == "KoLibris"
  end

  test "Info page and back" do
    navigate_to "/"
    link = find_element(:link_text, "Über KoLibris")
    click(link)
    assert current_path == "/about"
    assert page_title == "KoLibris - Über das Projekt"
    click(find_element(:link_text, "KoLibris"))
    assert current_path == "/"
  end

  test "Teachers page" do
    navigate_to "/"
    link = find_element(:link_text, "Selbst Aufgaben erstellen")
    click(link)
    assert current_path == "/selbst-aufgaben-erstellen"
    assert page_title == "KoLibris - Selbst Aufgaben erstellen"
    click(find_element(:link_text, "KoLibris"))
    assert current_path == "/"
  end

  test "Imprint page" do
    navigate_to "/"
    link = find_element(:link_text, "Impressum")
    click(link)
    assert current_path == "/impressum"
    assert page_title == "KoLibris - Impressum"
    click(find_element(:link_text, "KoLibris"))
    assert current_path == "/"
  end

  test "Login page" do
    navigate_to "/login"
    visible_page_text
    |> String.contains?("Administrator Login")
    |> assert("Expected certain login text")
    assert page_title == "KoLibris - Login"
    click(find_element(:link_text, "KoLibris"))
    assert current_path == "/"
  end

  test "Call to action" do
    navigate_to "/"
    link = find_element(:link_text, "Aufgaben für meinen Unterricht finden")
    click(link)
    assert current_path == "/aufgaben-finden"
    page_source
    |> String.contains?("Elm.Main.fullscreen()")
    |> assert("Expected Elm.")
  end
end
