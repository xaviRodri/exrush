defmodule ExrushTest do
  use ExUnit.Case

  describe "read_rushing/1" do
    test "Reading a file that exists returns its decoded data" do
      assert [
               %{
                 "1st" => _,
                 "1st%" => _,
                 "20+" => _,
                 "40+" => _,
                 "Att" => _,
                 "Att/G" => _,
                 "Avg" => _,
                 "FUM" => _,
                 "Lng" => _,
                 "Player" => _,
                 "Pos" => _,
                 "TD" => _,
                 "Team" => _,
                 "Yds" => _,
                 "Yds/G" => _
               }
             ] = Exrush.read_rushing("priv/rushing.json") |> Enum.take(1)
    end

    test "Attempting to read a non-existing file raises an error" do
      assert_raise File.Error, fn -> Exrush.read_rushing("invalid_file") end
    end
  end

  describe "player_filter/1" do
    test "Searching some existing player's name will return at least one result" do
      result = Exrush.player_filter("Shaun")

      assert Enum.count(result) >= 1
    end

    test "Searching for a non-existing player returns an empty list" do
      result = Exrush.player_filter("invalid_player")

      assert [] = result
    end

    test "Searching with something that is not a binary will return an empty list" do
      result = Exrush.player_filter(1234)

      assert [] = result
    end
  end

  describe "sort/2" do
    test "Sorting by any of the allowed fields returns a sortered list of data" do
      result_asc = Exrush.sort("TD", :asc)
      result_desc = Exrush.sort("TD", :desc)
      result_asc_lng = Exrush.sort("Lng", :asc)

      assert List.first(result_asc)["TD"] <= List.last(result_asc)["TD"]
      assert List.first(result_desc)["TD"] >= List.last(result_desc)["TD"]

      assert List.first(result_asc_lng)["Lng"] |> parse_value() <=
               List.last(result_asc_lng)["Lng"] |> parse_value()
    end

    test "Attempting to sort by a non-allowed field or filter will return an empty list" do
      result1 = Exrush.sort("NonAllowedField", :asc)
      result2 = Exrush.sort("TD", :non_allowed_filter)

      assert [] = result1
      assert [] = result2
    end
  end

  defp parse_value(value) when is_integer(value), do: value
  defp parse_value(value) when is_binary(value), do: Integer.parse(value) |> elem(0)
end
