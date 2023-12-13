defmodule Course.Client do
  use GenServer
  require Logger

  @timeout 4000
  @gen_server_timeout 10000

  @serviceType "course"

  def start_link(conn, uuidName) do
    name = {:via, Registry, {PidRegistry, uuidName}}
    GenServer.start_link(__MODULE__, conn, name: name)
  end

  def init(conn) do
    {:ok, conn}
  end

  def create_course(body, 2) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)
    Logger.info("Too many reroutes happened")

    case status do
      200 ->
        pid = SDClient.getProcessPid(@serviceType, address)
        GenServer.call(pid, {:create_course, body}, @gen_server_timeout)

      _ ->
        {:unavailable}
    end
  end

  def create_course(body, rerouteCounter) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)

    case status do
      200 ->
        pid = SDClient.getProcessPid(@serviceType, address)
        reply = GenServer.call(pid, {:create_course, body}, @gen_server_timeout)

        case reply do
          {:error, error} ->
            rerouteCounter = rerouteCounter + 1
            Logger.info("Rerouting happened #{rerouteCounter}")

            # reroute
            Course.Client.create_course(body, rerouteCounter)

          {:ok, response} ->
            {:ok, response}
        end

      _ ->
        {:unavailable}
    end
  end

  def create_lesson(body, 2) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)
    Logger.info("Too many reroutes happened")

    case status do
      200 ->
        pid = SDClient.getProcessPid(@serviceType, address)
        GenServer.call(pid, {:create_lesson, body}, @gen_server_timeout)

      _ ->
        {:unavailable}
    end
  end

  def create_lesson(body, rerouteCounter) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)

    case status do
      200 ->
        pid = SDClient.getProcessPid(@serviceType, address)
        reply = GenServer.call(pid, {:create_lesson, body}, @gen_server_timeout)

        case reply do
          {:error, error} ->
            rerouteCounter = rerouteCounter + 1
            Logger.info("Rerouting happened #{rerouteCounter}")

            # reroute
            Course.Client.create_lesson(body, rerouteCounter)

          {:ok, response} ->
            {:ok, response}
        end

      _ ->
        {:unavailable}
    end
  end

  def create_mark(body, 2) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)
    Logger.info("Too many reroutes happened")

    case status do
      200 ->
        pid = SDClient.getProcessPid(@serviceType, address)
        GenServer.call(pid, {:create_mark, body}, @gen_server_timeout)

      _ ->
        {:unavailable}
    end
  end

  def create_mark(body, rerouteCounter) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)

    case status do
      200 ->
        pid = SDClient.getProcessPid(@serviceType, address)
        reply = GenServer.call(pid, {:create_mark, body}, @gen_server_timeout)

        case reply do
          {:error, error} ->
            rerouteCounter = rerouteCounter + 1
            Logger.info("Rerouting happened #{rerouteCounter}")

            # reroute
            Course.Client.create_mark(body, rerouteCounter)

          {:ok, response} ->
            {:ok, response}
        end

      _ ->
        {:unavailable}
    end
  end

  def get_course(id, 2) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)
    Logger.info("Too many reroutes happened")

    case status do
      200 ->
        pid = SDClient.getProcessPid(@serviceType, address)
        GenServer.call(pid, {:get_course, id}, @gen_server_timeout)

      _ ->
        {:unavailable}
    end
  end

  def get_course(id, rerouteCounter) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)

    case status do
      200 ->
        pid = SDClient.getProcessPid(@serviceType, address)
        reply = GenServer.call(pid, {:get_course, id}, @gen_server_timeout)

        case reply do
          {:error, error} ->
            # increment reroute counter
            rerouteCounter = rerouteCounter + 1
            Logger.info("Rerouting happened #{rerouteCounter}")

            # reroute
            Course.Client.get_course(id, rerouteCounter)

          {:ok, response} ->
            {:ok, response}
        end

      _ ->
        {:unavailable}
    end
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

    resp = conn |> Course.CourseService.Stub.create_course(request, timeout: @timeout)
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

    resp = conn |> Course.CourseService.Stub.create_lesson(request, timeout: @timeout)
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

    resp = conn |> Course.CourseService.Stub.create_mark(request, timeout: @timeout)
    {:reply, resp, conn}
  end

  def handle_call({:get_course, id}, _from, conn) do
    request = %Course.CourseID{id: id}
    resp = conn |> Course.CourseService.Stub.get_course(request, timeout: @timeout)

    {:reply, resp, conn}
  end
end
