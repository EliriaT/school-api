# elixir --no-halt lib/gateway.ex
# iex -S mix run
# Gateway.start(nil,nil)
# PATH=~/.mix/escripts:$PATH
# protoc --elixir_out=plugins=grpc:. ./lib/auth/auth.proto

defmodule Gateway do
  use Plug.Router
  require Logger

  plug(Plug.Logger)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "world")
  end

  post "/users" do
    case conn.body_params do
      %{
        "email" => email,
        "password" => password,
        "name" => name,
        "schoolId" => schoolId,
        "roleId" => roleId
      } = body ->
        # here service high availability and circuit breaker happens
        reply = Auth.Client.register(body, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            Logger.info("No service is available")

            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            Logger.info("No service is available")

            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, user} ->
            jsonResp = Protobuf.JSON.encode(user)

            case jsonResp do
              {:ok, jsonResp} ->
                conn
                |> put_resp_content_type("application/json")
                |> send_resp(user.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  post "/users/login" do
    case conn.body_params do
      %{
        "email" => email,
        "password" => password
      } = body ->
        reply = Auth.Client.login(body, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, user} ->
            jsonResp = Protobuf.JSON.encode(user)

            case jsonResp do
              {:ok, jsonResp} ->
                conn
                |> put_resp_content_type("application/json")
                |> send_resp(user.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  post "/users/token" do
    case conn.body_params do
      %{
        "token" => token
      } ->
        reply = Auth.Client.validate(token, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, user} ->
            jsonResp = Protobuf.JSON.encode(user)

            case jsonResp do
              {:ok, jsonResp} ->
                conn
                |> put_resp_content_type("application/json")
                |> send_resp(user.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  get "/users/:id" do
    # Extract from cache if present

    node = HashRing.Managed.key_to_node(:myring, "user" <> id)
    Logger.info("Getting from cache at #{node}")

    case Redix.command(node, ["GET", "user" <> id]) do
      {:ok, nil} ->
        id = String.to_integer(id)

        reply = Auth.Client.get_user(id, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, user} ->
            jsonResp = Protobuf.JSON.encode(user)

            case jsonResp do
              {:ok, jsonResp} ->
                # Put in cache
                if user.status != 404 do
                  Redix.command(node, [
                    "SET",
                    "user" <> Integer.to_string(user.data.id),
                    jsonResp
                  ])
                end

                conn
                |> put_resp_content_type("application/json")
                |> send_resp(user.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end

          _ ->
            send_resp(conn, 500, "")
        end

      {:ok, body} ->
        {:ok, respMap} = Protobuf.JSON.decode(body, Auth.UserResponse)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(respMap.status, body)
    end
  end

  post "/schools" do
    case conn.body_params do
      %{
        "name" => name
      } = body ->
        reply = School.Client.create_school(body, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, protoReply} ->
            jsonResp = Protobuf.JSON.encode(protoReply)

            case jsonResp do
              {:ok, jsonResp} ->
                conn
                |> put_resp_content_type("application/json")
                |> send_resp(protoReply.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  post "/class" do
    case conn.body_params do
      %{
        "headTeacher" => headTeacher,
        "name" => name,
        "schoolId" => schoolId
      } = body ->
        reply = School.Client.create_class(body, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, protoReply} ->
            jsonResp = Protobuf.JSON.encode(protoReply)

            case jsonResp do
              {:ok, jsonResp} ->
                conn
                |> put_resp_content_type("application/json")
                |> send_resp(protoReply.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  post "/student" do
    case conn.body_params do
      %{
        "classID" => classID,
        "userID" => userID
      } = body ->
        reply = School.Client.create_student(body, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, protoReply} ->
            jsonResp = Protobuf.JSON.encode(protoReply)

            case jsonResp do
              {:ok, jsonResp} ->
                conn
                |> put_resp_content_type("application/json")
                |> send_resp(protoReply.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  get "/class/:id" do
    node = HashRing.Managed.key_to_node(:myring, "class" <> id)
    Logger.info("Getting from cache at #{node}")

    # Extract from cache if present
    case Redix.command(node, ["GET", "class" <> id]) do
      {:ok, nil} ->
        id = String.to_integer(id)

        reply = School.Client.get_class(id, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, class} ->
            jsonResp = Protobuf.JSON.encode(class)

            case jsonResp do
              {:ok, jsonResp} ->
                if class.status != 404 do
                  Redix.command(node, [
                    "SET",
                    "class" <> Integer.to_string(class.data.id),
                    jsonResp
                  ])
                end

                conn
                |> put_resp_content_type("application/json")
                |> send_resp(class.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end

          _ ->
            send_resp(conn, 500, "")
        end

      {:ok, body} ->
        {:ok, respMap} = Protobuf.JSON.decode(body, School.ClassResponse)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(respMap.status, body)
    end
  end

  # course service

  post "/course" do
    case conn.body_params do
      %{
        "classId" => classId,
        "name" => name,
        "teacherId" => teacherId
      } = body ->
        reply = Course.Client.create_course(body, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, protoReply} ->
            jsonResp = Protobuf.JSON.encode(protoReply)

            case jsonResp do
              {:ok, jsonResp} ->
                conn
                |> put_resp_content_type("application/json")
                |> send_resp(protoReply.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  get "/course/:id" do
    node = HashRing.Managed.key_to_node(:myring, "course" <> id)
    Logger.info("Getting from cache at #{node}")

    case Redix.command(node, ["GET", "course" <> id]) do
      {:ok, nil} ->
        Logger.info("No course data found in cache")
        id = String.to_integer(id)

        reply = Course.Client.get_course(id, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, course} ->
            jsonResp = Protobuf.JSON.encode(course)

            case jsonResp do
              {:ok, jsonResp} ->
                if course.status != 404 do
                  Redix.command(node, [
                    "SET",
                    "course" <> Integer.to_string(course.data.id),
                    jsonResp
                  ])
                end

                conn
                |> put_resp_content_type("application/json")
                |> send_resp(course.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end

          _ ->
            send_resp(conn, 500, "")
        end

      {:ok, body} ->
        Logger.info("Received from cache course info")
        {:ok, respMap} = Protobuf.JSON.decode(body, Course.CourseResponse)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(respMap.status, body)
    end
  end

  post "/lesson" do
    case conn.body_params do
      %{
        "classRoom" => classRoom,
        "courseId" => courseId,
        "startHour" => startHour,
        "endHour" => endHour,
        "name" => name,
        "weekDay" => weekDay
      } = body ->
        reply = Course.Client.create_lesson(body, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, protoReply} ->
            jsonResp = Protobuf.JSON.encode(protoReply)

            case jsonResp do
              {:ok, jsonResp} ->
                conn
                |> put_resp_content_type("application/json")
                |> send_resp(protoReply.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  post "/mark" do
    case conn.body_params do
      %{
        "courseId" => courseId,
        "isAbsent" => isAbsent,
        "mark" => mark,
        "markDate" => markDate,
        "studentId" => studentId
      } = body ->
        reply = Course.Client.create_mark(body, 0)

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, protoReply} ->
            jsonResp = Protobuf.JSON.encode(protoReply)
            Logger.info("Removing info of course #{courseId} from cache")

            node = HashRing.Managed.key_to_node(:myring, "course" <> courseId)
            Logger.info("Removing info of course from cache at #{node}")

            Redix.command(node, ["DEL", "course" <> courseId])

            case jsonResp do
              {:ok, jsonResp} ->
                conn
                |> put_resp_content_type("application/json")
                |> send_resp(protoReply.status, jsonResp)

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  post "/teacher/course" do
    case conn.body_params do
      %{
        "email" => email,
        "password" => password,
        "name" => name,
        "schoolId" => schoolId,
        "roleId" => roleId,
        "classId" => classId,
        "course_name" => course_name
      } = body ->
        reply =
          Auth.Client.register(
            %{
              "email" => email,
              "password" => password,
              "name" => name,
              "schoolId" => schoolId,
              "roleId" => roleId
            },
            0
          )

        case reply do
          {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
            Logger.info("No service is available")

            conn
            |> put_resp_header("Connection", "close")
            |> send_resp(408, "Request timeout")

          {:error, error} ->
            Logger.info("No service is available")

            send_resp(conn, 500, error)

          {:unavailable} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')

          {:ok, user} ->
            jsonResp = Protobuf.JSON.encode(user)

            case jsonResp do
              {:ok, jsonResp} ->
                case user.status do
                  201 ->
                    # Teacher was created successfully, so now lets create the course for that teacher

                    # retrieve teacherId
                    teacherId = user.userId
                    Logger.info("Teacher was created succesfully")

                    createCourse(conn, %{
                      "classId" => "#{classId}",
                      "name" => course_name,
                      "teacherId" => "#{teacherId}"
                    })

                    conn
                    |> put_resp_content_type("application/json")
                    |> send_resp(user.status, jsonResp)

                  _ ->
                    conn
                    |> put_resp_content_type("application/json")
                    |> send_resp(user.status, jsonResp)
                end

              {:error, _} ->
                send_resp(conn, 500, "json encoding failed")
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  def createCourse(
        conn,
        %{
          "classId" => classId,
          "name" => course_name,
          "teacherId" => teacherId
        } = request
      ) do
    reply = Course.Client.create_course(request, 0)

    case reply do
      {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
        Logger.info("Failed to create the teacher. Reason timeone. ")

        # delete user
        deleteTeacherUser(conn, teacherId)

        conn
        |> put_resp_header("Connection", "close")
        |> send_resp(408, "Request timeout")

      {:error, error} ->
        Logger.info("Failed to create the teacher. Reason 500.")

        # delete user
        deleteTeacherUser(conn, teacherId)

        send_resp(conn, 500, error)

      {:unavailable} ->
        Logger.info("Failed to create the teacher. Reason no services available.")

        # delete user
        deleteTeacherUser(conn, teacherId)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(503, 'unavailable')

      {:ok, protoReply} ->
        jsonResp = Protobuf.JSON.encode(protoReply)

        case jsonResp do
          {:ok, jsonResp} ->
            Logger.info("Course created succesfully for teacher #{teacherId}. ")

            conn
            |> put_resp_content_type("application/json")
            |> send_resp(protoReply.status, jsonResp)

          {:error, _} ->
            send_resp(conn, 500, "json encoding failed")
        end
    end
  end

  def deleteTeacherUser(conn, teacherId) do
    teacherId = String.to_integer(teacherId)
    reply = Auth.Client.delete_user(teacherId, 0)

    case reply do
      {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
        Logger.info("Failed to delete teacher user #{teacherId}")

        conn
        |> put_resp_header("Connection", "close")
        |> send_resp(408, "Request timeout")

      {:error, error} ->
        Logger.info("Failed to delete teacher user #{teacherId}")

        send_resp(conn, 500, error)

      {:unavailable} ->
        Logger.info("Failed to delete teacher user #{teacherId}")

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(503, 'unavailable')

      {:ok, response} ->
        nil
    end
  end

  get "/health" do
    # check if each service has a connection and then return 200

    %{"replicas" => schoolServices, "status" => status} = SDClient.getReplicas("school")
    %{"replicas" => courseServices, "status" => status} = SDClient.getReplicas("course")

    status = if Enum.empty?(schoolServices) || Enum.empty?(courseServices), do: 503, else: 200

    body = %{"schoolReplicas" => schoolServices, "courseReplicas" => courseServices}

    reply = Jason.encode!(body)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, reply)
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, "Not Found")
  end
end
