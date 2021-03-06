defmodule ExrushWeb.PageLiveTest do
  use ExrushWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to The Score!"
    assert render(page_live) =~ "Welcome to The Score!"
  end
end
