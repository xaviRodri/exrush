defmodule ExrushWeb.PageLive do
  @moduledoc false

  use ExrushWeb, :live_view

  @cols [
    {"Player", false},
    {"Team", false},
    {"Pos", false},
    {"Att/G", false},
    {"Att", false},
    {"Yds", true},
    {"Avg", false},
    {"Yds/G", false},
    {"TD", true},
    {"Lng", true},
    {"1st", false},
    {"1st%", false},
    {"20+", false},
    {"40+", false},
    {"FUM", false}
  ]
  @default_page_config %{page: 1, page_size: 10}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       query: "",
       cols: @cols,
       page: Exrush.get_rushing() |> Exrush.paginate(@default_page_config),
       page_config: @default_page_config,
       sort_by: nil,
       sort_field: nil,
       sort_order: nil
     )}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case Exrush.player_filter(query) do
      [] ->
        {:noreply,
         socket
         |> put_flash(:error, "No players found matching \"#{query}\"")
         |> assign(page: empty_page(socket.assigns.page), query: query)}

      data ->
        {:noreply,
         assign(socket,
           page: data |> Exrush.paginate(@default_page_config),
           query: query,
           sort_field: nil,
           sort_order: nil
         )}
    end
  end

  @impl true
  def handle_params(%{"sort_by" => sort_by}, _uri, socket) do
    order =
      if socket.assigns.sort_field != sort_by,
        do: :asc,
        else: swap_order(socket.assigns.sort_order)

    Exrush.player_filter(socket.assigns.query)
    |> Exrush.sort(sort_by, order)
    |> case do
      [] ->
        {:noreply,
         socket
         |> put_flash(:error, "Filtering error. View restarted.")
         |> assign(
           page: Exrush.get_rushing() |> Exrush.paginate(@default_page_config),
           sort_field: nil
         )}

      data ->
        {:noreply,
         assign(socket,
           page: data |> Exrush.paginate(@default_page_config),
           sort_field: sort_by,
           sort_order: order
         )}
    end
  end

  def handle_params(%{"page" => page_number}, _uri, socket) do
    page =
      Exrush.player_filter(socket.assigns.query)
      |> Exrush.sort(socket.assigns.sort_field, socket.assigns.sort_order)
      |> Exrush.paginate(%{page: page_number, page_size: socket.assigns.page.page_size})

    {:noreply, assign(socket, page: page)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp empty_page(%{page_size: page_size}),
    do: %{entries: [], page_number: 1, page_size: page_size, total_pages: 1}

  defp swap_order(nil), do: :asc
  defp swap_order(:asc), do: :desc
  defp swap_order(:desc), do: :asc
end
