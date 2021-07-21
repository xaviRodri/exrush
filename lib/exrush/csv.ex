defmodule Exrush.Csv do
  @moduledoc """
  This module is in charge of all operations related to
  CSV files management.
  """

  @csv_path "priv/csv/"

  @doc """
  Writes a list of rushing data into a CSV file.
  """
  @spec write(list()) :: binary()
  def write(data_list) do
    file_name = Enum.join([@csv_path, DateTime.utc_now() |> DateTime.to_iso8601(), ".csv"])
    maybe_create_dir()
    file = File.open!(file_name, [:write, :utf8])

    data_list
    |> CSV.encode(headers: true)
    |> Enum.each(&IO.write(file, &1))

    file_name
  end

  defp maybe_create_dir, do: unless(File.dir?(@csv_path), do: File.mkdir!(@csv_path))
end
