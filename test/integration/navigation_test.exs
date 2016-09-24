defmodule NavigationTest do
  use Kompax.IntegrationCase

  alias Kompax.Copytext

  setup do
    %Copytext{slug: "about", body: "about blabla"} |> Repo.insert!
    %Copytext{slug: "aufgaben-erstellen", body: "erstellen blabla"} |> Repo.insert!
    %Copytext{slug: "impressum", body: "impressum blabla"} |> Repo.insert!
    :ok
  end

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
    assert visible_page_text =~ "about blabla"
    click(find_element(:link_text, "KoLibris"))
    assert current_path == "/"
  end

  test "Teachers page" do
    navigate_to "/"
    link = find_element(:link_text, "Aufgaben erstellen")
    click(link)
    assert current_path == "/aufgaben-erstellen"
    assert page_title == "KoLibris - Aufgaben erstellen"
    assert visible_page_text =~ "erstellen blabla"
    click(find_element(:link_text, "KoLibris"))
    assert current_path == "/"
  end

  test "Imprint page" do
    navigate_to "/"
    link = find_element(:link_text, "Impressum")
    click(link)
    assert current_path == "/impressum"
    assert page_title == "KoLibris - Impressum"
    assert visible_page_text =~ "impressum blabla"
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
