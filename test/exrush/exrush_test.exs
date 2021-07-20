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
end
