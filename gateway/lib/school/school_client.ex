defmodule School.Client do
  use GenServer
  require Logger

  def start_link(conn) do
    GenServer.start_link(__MODULE__, conn, name: __MODULE__)
  end

  def init(conn) do
    {:ok, conn}
  end

  def get_class(id) do
    GenServer.call(__MODULE__, {:get_class, id})
  end

  def handle_call({:get_class, id}, _from, conn) do
    request = %School.ID{id: id}
    resp = conn |> School.SchoolService.Stub.get_class(request)
    {:reply, resp, conn}
  end

end
