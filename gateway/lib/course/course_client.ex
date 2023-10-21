defmodule Course.Client do
  use GenServer
  require Logger

  def start_link(conn) do
    GenServer.start_link(__MODULE__, conn, name: __MODULE__)
  end

  def init(conn) do
    {:ok, conn}
  end

  def get_course(id) do
    GenServer.call(__MODULE__, {:get_course, id})
  end

  def handle_call({:get_course, id}, _from, conn) do
    request = %Course.CourseID{id: id}
    resp = conn |> Course.CourseService.Stub.get_course(request)
    {:reply, resp, conn}
  end

end
