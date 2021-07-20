defmodule Exrush.RushingReader do
  @moduledoc """
  Module in charge of reading and decoding the rushing JSON file
  at the application startup.
  It stores the data in memory, so
  """

  use GenServer

  ###############
  ## Callbacks ##
  ###############

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  @impl true
  def init(_), do: {:ok, [], {:continue, :feed}}

  @impl true
  def handle_continue(:feed, _state), do: {:noreply, Exrush.read_rushing()}

  @impl true
  def handle_call(:get, _from, state), do: {:reply, state, state}

  #########
  ## API ##
  #########

  @doc """
  Returns the list of rushing data that is stored in the GenServer's state.
  """
  def get_rushing, do: GenServer.call(__MODULE__, :get)
end
