defmodule Exrush do
  @moduledoc """
  Exrush keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @rushing_path "priv/rushing.json"

  @doc """
  Reads and decodes the rushing JSON file.
  """
  @spec read_rushing() :: list(map()) | map()
  def read_rushing(path \\ @rushing_path) do
    path
    |> File.read!()
    |> Jason.decode!()
  end

  # def sort(rushing_list, field, :asc) do
  #  rushing_list
  #  |> Enum.sort(&(&1[field] <= &2[field]))
  # end

  # def sort(rushing_list, field, :desc) do
  #  rushing_list
  #  |> Enum.sort(&(&1[field] >= &2[field]))
  # end
end
