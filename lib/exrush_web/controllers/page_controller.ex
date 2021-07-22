defmodule ExrushWeb.PageController do
  use ExrushWeb, :controller

  @doc """
  Emits a download of the data requested to the client.
  """
  def download(conn, %{
        "download" => %{"search" => "", "sort_field" => "", "sort_order" => _sort_order}
      }) do
    path = Exrush.get_rushing() |> Exrush.Csv.write()

    send_download(conn, {:file, path})
  end

  def download(conn, %{
        "download" => %{"search" => query, "sort_field" => "", "sort_order" => _sort_order}
      }) do
    path = Exrush.player_filter(query) |> Exrush.Csv.write()

    send_download(conn, {:file, path})
  end

  def download(conn, %{
        "download" => %{"search" => "", "sort_field" => sort_field, "sort_order" => sort_order}
      }) do
    path =
      Exrush.get_rushing()
      |> Exrush.sort(sort_field, String.to_atom(sort_order))
      |> Exrush.Csv.write()

    send_download(conn, {:file, path})
  end

  def download(conn, %{
        "download" => %{"search" => query, "sort_field" => sort_field, "sort_order" => sort_order}
      }) do
    path =
      Exrush.player_filter(query)
      |> Exrush.sort(sort_field, String.to_atom(sort_order))
      |> Exrush.Csv.write()

    send_download(conn, {:file, path})
  end
end
