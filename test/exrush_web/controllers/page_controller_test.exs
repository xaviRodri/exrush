defmodule ExrushWeb.PageControllerTest do
  use ExrushWeb.ConnCase

  describe "/download" do
    test "Downloading the list will trigger a CSV file download", %{conn: conn} do
      conn =
        get(conn, "/download", %{
          "download" => %{"search" => "", "sort_field" => "", "sort_order" => ""}
        })

      assert response_content_type(conn, :csv)
      assert response(conn, 200)
    end

    test "Downloading the list with a search will return only results matching the search", %{
      conn: conn
    } do
      conn =
        get(conn, "/download", %{
          "download" => %{"search" => "Jo", "sort_field" => "", "sort_order" => ""}
        })

      # Only 1 entry should match the query
      {:ok, out} = conn.resp_body |> StringIO.open()

      decoded_download =
        IO.binstream(out, :line) |> CSV.Decoding.Decoder.decode(headers: true) |> Enum.map(& &1)

      assert response_content_type(conn, :csv)
      assert response(conn, 200)
      assert Enum.count(decoded_download) == 1
    end

    test "Downloading a sorted list will return the results sorted", %{
      conn: conn
    } do
      conn =
        get(conn, "/download", %{
          "download" => %{"search" => "", "sort_field" => "Yds", "sort_order" => "asc"}
        })

      # Only 1 entry should match the query
      {:ok, out} = conn.resp_body |> StringIO.open()

      decoded_download =
        IO.binstream(out, :line) |> CSV.Decoding.Decoder.decode(headers: true) |> Enum.map(& &1)

      download_results = Enum.map(decoded_download, fn {:ok, item} -> item["Player"] end)

      assert response_content_type(conn, :csv)
      assert response(conn, 200)
      assert download_results == Exrush.sort("Yds", :asc) |> Enum.map(& &1["Player"])
    end

    test "Downloading a sorted list with a search will return sorted results matching the search",
         %{
           conn: conn
         } do
      conn =
        get(conn, "/download", %{
          "download" => %{"search" => "White", "sort_field" => "Yds", "sort_order" => "asc"}
        })

      # Only 1 entry should match the query
      {:ok, out} = conn.resp_body |> StringIO.open()

      decoded_download =
        IO.binstream(out, :line) |> CSV.Decoding.Decoder.decode(headers: true) |> Enum.map(& &1)

      download_results = Enum.map(decoded_download, fn {:ok, item} -> item["Player"] end)

      assert response_content_type(conn, :csv)
      assert response(conn, 200)
      assert Enum.count(decoded_download) == 2

      assert download_results ==
               Exrush.player_filter("White")
               |> Exrush.sort("Yds", :asc)
               |> Enum.map(& &1["Player"])
    end
  end
end
