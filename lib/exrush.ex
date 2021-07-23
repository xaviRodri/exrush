defmodule Exrush do
  @moduledoc """
  Exrush is the module that contains the main business logic.
  """

  @allowed_sort_fields ["Yds", "Lng", "TD", nil]
  @allowed_filters [:asc, :desc]
  @rushing_path Application.compile_env!(:exrush, :json_path)

  @doc """
  Reads and decodes the rushing JSON file.
  """
  @spec read_rushing() :: list(map()) | map()
  def read_rushing(path \\ @rushing_path) do
    path
    |> File.read!()
    |> Jason.decode!()
  end

  @doc """
  Retrieves the rushing data from the reader process.
  """
  @spec get_rushing() :: [map()]
  def get_rushing, do: Exrush.RushingReader.get_rushing()

  @doc """
  Paginates a list of data using `Scrivener.List`.
  """
  @spec paginate(list(), %{page: integer(), page_size: integer()}) :: Scrivener.Page.t()
  def paginate(data_list, %{page: _page_number, page_size: _page_size} = config),
    do: Scrivener.paginate(data_list, config)

  @doc """
  Filters the rushing data by player.
  Uses a simple algorithm that looks for a containing match in the data.

  If the query filter is empty, will return all the entries.
  """
  @spec player_filter(binary()) :: list(map())
  def player_filter(""), do: Exrush.RushingReader.get_rushing()

  def player_filter(search) when is_binary(search) do
    Exrush.RushingReader.get_rushing()
    |> Enum.filter(&String.contains?(&1["Player"] |> String.downcase(), String.downcase(search)))
  end

  def player_filter(_search), do: []

  @doc """
  Sorts the rushing data list by an specified list.
  Accepts both :asc and :desc order.
  """
  @spec sort(binary(), atom()) :: list(map())
  def sort(field, filter) when field in @allowed_sort_fields and filter in @allowed_filters do
    Exrush.RushingReader.get_rushing()
    |> sort(field, filter)
  end

  def sort(_field, _filter), do: []

  def sort(rushing_list, nil, _), do: rushing_list

  def sort(rushing_list, field, :asc) do
    rushing_list
    |> Enum.sort(&(parse_sort_value(&1[field]) <= parse_sort_value(&2[field])))
  end

  def sort(rushing_list, field, :desc) do
    rushing_list
    |> Enum.sort(&(parse_sort_value(&1[field]) >= parse_sort_value(&2[field])))
  end

  defp parse_sort_value(value) when is_integer(value), do: value

  defp parse_sort_value(value) when is_binary(value),
    do: String.replace(value, ",", ".") |> Float.parse() |> elem(0)
end
