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
  @sort_order %{"Yds" => :asc, "TD" => :asc, "Lng" => :asc}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, query: "", data: get_rushing_data(), cols: @cols, sort_order: @sort_order)}
  end

  @impl true
  def handle_event("search", %{"q" => ""}, socket) do
    {:noreply, assign(socket, data: get_rushing_data(), query: "")}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case Exrush.player_filter(query) do
      [] ->
        {:noreply,
         socket
         |> put_flash(:error, "No players found matching \"#{query}\"")
         |> assign(data: [], query: query)}

      data ->
        {:noreply, assign(socket, data: data, query: query)}
    end
  end

  @impl true
  def handle_params(%{"sort_by" => sort_by}, _uri, socket) do
    case Exrush.sort(socket.assigns.data, sort_by, socket.assigns.sort_order[sort_by]) do
      [] ->
        {:noreply,
         socket
         |> put_flash(:error, "Filtering error. View restarted.")
         |> assign(data: get_rushing_data())}

      data ->
        {:noreply,
         assign(socket, data: data, sort_order: swap_order(socket.assigns.sort_order, sort_by))}
    end
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp get_rushing_data, do: Exrush.RushingReader.get_rushing()

  defp swap_order(order_map, field) do
    case order_map[field] do
      :asc -> Map.put(order_map, field, :desc)
      :desc -> Map.put(order_map, field, :asc)
    end
  end
end
