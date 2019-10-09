defmodule ExHttpMock.State do
  @moduledoc false

  alias ExHttpMock.Parse

  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: State)
  end

  def get_path(http_path) do
    GenServer.call(State, {:get, http_path})
  end

  # ---------------------------------------------
  #                    CALLBACK
  # ---------------------------------------------
  @impl true
  def init(_state) do
    state = Parse.mock_file_path()

    {:ok, state}
  end

  @impl true
  def handle_call({:get, http_path}, _from, state) do
    IO.inspect(state, label: State)
    {:reply, Map.get(state, http_path), state}
  end
end
