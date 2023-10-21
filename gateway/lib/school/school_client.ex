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

  def create_school(body) do
    GenServer.call(__MODULE__, {:create_school, body})
  end

  def create_class(body) do
    GenServer.call(__MODULE__, {:create_class, body})
  end

  def create_student(body) do
    GenServer.call(__MODULE__, {:create_student, body})
  end

  def handle_call({:get_class, id}, _from, conn) do
    request = %School.ID{id: id}
    resp = conn |> School.SchoolService.Stub.get_class(request, timeout: 1500)
    {:reply, resp, conn}
  end

  def handle_call({:create_school, %{"name" => name}}, _from, conn) do
    request = %School.SchoolRequest{name: name}

    resp = conn |> School.SchoolService.Stub.create_school(request, timeout: 1500)
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

    resp = conn |> School.SchoolService.Stub.create_class(request, timeout: 1500)
    {:reply, resp, conn}
  end

  def handle_call({:create_student, %{"userID" => userID, "classID" => classID }},_from, conn ) do
    request = %School.StudentRequest{
      userID: String.to_integer(userID),
      classID: String.to_integer(classID)
    }

    resp = conn |> School.SchoolService.Stub.create_student(request, timeout: 1500)
    {:reply, resp, conn}
  end
end
