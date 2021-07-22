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

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       query: "",
       data: Exrush.get_rushing(),
       cols: @cols,
       sort_by: nil,
       sort_field: nil,
       sort_order: :asc
     )}
  end

  @impl true
  def handle_event("search", %{"q" => ""}, socket) do
    {:noreply, assign(socket, data: Exrush.get_rushing(), query: "")}
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
    order = if socket.assigns.sort_field != sort_by, do: :asc, else: socket.assigns.sort_order

    case Exrush.sort(socket.assigns.data, sort_by, order) do
      [] ->
        {:noreply,
         socket
         |> put_flash(:error, "Filtering error. View restarted.")
         |> assign(data: Exrush.get_rushing(), sort_field: nil)}

      data ->
        {:noreply,
         assign(socket,
           data: data,
           sort_field: sort_by,
           sort_order: swap_order(socket.assigns.sort_field, order)
         )}
    end
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp swap_order(sort_field, :asc) when sort_field == nil, do: :desc
  defp swap_order(_sort_field, :asc), do: :desc
  defp swap_order(_sort_field, :desc), do: :asc
end
