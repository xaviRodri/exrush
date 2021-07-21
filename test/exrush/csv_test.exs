defmodule Exrush.CsvTest do
  use ExUnit.Case

  describe "write/2" do
    @valid_data [%{a: 1, b: 2}, %{a: 3, b: 4}]
    @invalid_data 1
    test "Writes the data into a csv file if the params are correct" do
      file_path = Exrush.Csv.write(@valid_data)

      assert File.exists?(file_path)

      # Removing the test file
      File.rm!(file_path)
    end

    test "Attempting to write invalid data will raise an error" do
      assert_raise Protocol.UndefinedError, fn -> Exrush.Csv.write(@invalid_data) end
    end
  end
end
