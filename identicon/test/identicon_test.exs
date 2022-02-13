defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  test "hash_input returns an Image struct with the hex property set as a list of numbers" do
    assert Identicon.hash_input("Theo") == %Identicon.Image{
             color: nil,
             grid: nil,
             hex: [100, 140, 75, 132, 17, 70, 9, 237, 246, 25, 190, 13, 228, 226, 127, 173],
             pixel_map: nil
           }
  end

  test "hash_input always returns the exact same output for the same string" do
    assert Identicon.hash_input("Theo") == Identicon.hash_input("Theo")
  end

  test "hash_input returns different output for the sae string with different capitalization" do
    assert Identicon.hash_input("cat") != Identicon.hash_input("Cat")
  end

  test "hash_input returns a valid struct when input includes punctuation" do
    assert Identicon.hash_input("!@#$%") == %Identicon.Image{
             color: nil,
             grid: nil,
             hex: [80, 114, 80, 185, 71, 204, 57, 112, 35, 169, 89, 80, 1, 252, 241, 103],
             pixel_map: nil
           }
  end
end
