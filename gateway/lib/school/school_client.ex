defmodule School.Client do
  use GenServer
  require Logger

  @timeout 4000
  @gen_server_timeout 10000

  def start_link(conn, uuidName) do
    name = {:via, Registry, {PidRegistry, uuidName}}
    GenServer.start_link(__MODULE__, conn, name: name)
  end

  def init(conn) do
    {:ok, conn}
  end

  def get_class(pid,id) do
    GenServer.call(pid, {:get_class, id},  @gen_server_timeout)
  end

  def create_school(pid,body) do
    GenServer.call(pid, {:create_school, body}, @gen_server_timeout)
  end

  def create_class(pid,body) do
    GenServer.call(pid, {:create_class, body},  @gen_server_timeout)
  end

  def create_student(pid,body) do
    GenServer.call(pid, {:create_student, body}, @gen_server_timeout)
  end

  def handle_call({:get_class, id}, _from, conn) do
    request = %School.ID{id: id}
    resp = conn |> School.SchoolService.Stub.get_class(request, timeout: @timeout)
    {:reply, resp, conn}
  end

  def handle_call({:create_school, %{"name" => name}}, _from, conn) do
    request = %School.SchoolRequest{name: name}

    resp = conn |> School.SchoolService.Stub.create_school(request, timeout: @timeout)
    {:reply, resp, conn}
  end

  def handle_call(
        {:create_class, %{"headTeacher" => headTeacher, "name" => name, "schoolId" => schoolId}},
        _from,
        conn
      ) do
    request = %School.ClassRequest{
      name: name,
      headTeacher: String.to_integer(headTeacher),
      schoolId: String.to_integer(schoolId)
    }

    resp = conn |> School.SchoolService.Stub.create_class(request, timeout: @timeout)
    {:reply, resp, conn}
  end

  def handle_call({:create_student, %{"userID" => userID, "classID" => classID }},_from, conn ) do
    request = %School.StudentRequest{
      userID: String.to_integer(userID),
      classID: String.to_integer(classID)
    }

    resp = conn |> School.SchoolService.Stub.create_student(request, timeout: @timeout)
    {:reply, resp, conn}
  end
end
