defmodule Course.Client do
  use GenServer
  require Logger

  def start_link(conn) do
    GenServer.start_link(__MODULE__, conn, name: __MODULE__)
  end

  def init(conn) do
    {:ok, conn}
  end

  def create_course(body) do
    GenServer.call(__MODULE__, {:create_course, body})
  end

  def create_lesson(body) do
    GenServer.call(__MODULE__, {:create_lesson, body})
  end

  def create_mark(body) do
    GenServer.call(__MODULE__, {:create_mark, body})
  end

  def get_course(id) do
    GenServer.call(__MODULE__, {:get_course, id})
  end

  def handle_call(
        {:create_course, %{"classId" => classId, "name" => name, "teacherId" => teacherId}},
        _from,
        conn
      ) do
    request = %Course.CourseRequest{
      classId: String.to_integer(classId),
      name: name,
      teacherId: String.to_integer(teacherId)
    }

    resp = conn |> Course.CourseService.Stub.create_course(request)
    {:reply, resp, conn}
  end

  def handle_call(
        {:create_lesson,
         %{
           "classRoom" => classRoom,
           "courseId" => courseId,
           "startHour" => startHour,
           "endHour" => endHour,
           "name" => name,
           "weekDay" => weekDay
         }},
        _from,
        conn
      ) do
    request = %Course.LessonRequest{
      classRoom: classRoom,
      courseId: String.to_integer(courseId),
      startHour: startHour,
      endHour: endHour,
      name: name,
      weekDay: weekDay
    }

    resp = conn |> Course.CourseService.Stub.create_lesson(request)
    {:reply, resp, conn}
  end

  def handle_call(
        {:create_mark,
         %{
           "courseId" => courseId,
           "isAbsent" => isAbsent,
           "mark" => mark,
           "markDate" => markDate,
           "studentId" => studentId
         }},
        _from,
        conn
      ) do
    request = %Course.MarkRequest{
      # TODO Think of a better way to transform to int in case it is already an int
      courseId: String.to_integer(courseId),
      isAbsent: isAbsent,
      mark: mark,
      markDate: markDate,
      studentId: String.to_integer(studentId)
    }

    resp = conn |> Course.CourseService.Stub.create_mark(request)
    {:reply, resp, conn}
  end

  def handle_call({:get_course, id}, _from, conn) do
    request = %Course.CourseID{id: id}
    resp = conn |> Course.CourseService.Stub.get_course(request)
    {:reply, resp, conn}
  end
end
