defmodule Kompax.MoekdownTest do
  use ExUnit.Case, async: true

  alias Kompax.Moekdown

  test "one line" do
    assert Moekdown.html("Hello World!") == "<p>Hello World!</p>"
  end

  test "two lines" do
    assert Moekdown.html("veggies\nbread") == "<p>veggies</p><p>bread</p>"
  end

  # test "one bullet" do
  #   assert Moekdown.html("veggies\n*carrot") == "<p>veggies<ul><li>carrot</li></ul></p>"
  # end

  # test "two bullets" do
  #   assert Moekdown.html("veggies\n*carrot\n*potato") == "<p>veggies<ul><li>carrot</li><li>potato</li></ul></p>"
  # end

  # test "sub-bullets and then bullet" do
  #   assert Moekdown.html("food\n*veggies\n**carrot\n**potato\n*bread") == "<p>food<ul><li>veggies</li><li><ul><li>carrot</li><li>potato</li></ul></li><li>bread</li></ul></p>"
  # end

  # test "sub-bullets and then non-bullet" do
  #   assert Moekdown.html("food\n*veggies\n**carrot\n**potato\nrainbow") == "<p>food<ul><li>veggies</li><li><ul><li>carrot</li><li>potato</li></ul></li><li>rainbow</li></ul></p>"
  # end
end
