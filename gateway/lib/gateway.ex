# elixir --no-halt lib/gateway.ex
# iex -S mix run
# Gateway.start(nil,nil)
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
        serviceType = "school"
        actualServiceType = "auth"

        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            # nu poate fi ca procesul sa nu fi fost inregistrat, de asta pid nu poate fi false
            pid = SDClient.getProcessPid(actualServiceType, address)

            reply = Auth.Client.register(pid, body)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

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
            |> send_resp(503, 'unavailable')
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
        serviceType = "school"
        actualServiceType = "auth"

        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(actualServiceType, address)
            reply = Auth.Client.login(pid, body)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

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
            |> send_resp(503, 'unavailable')
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
        serviceType = "school"
        actualServiceType = "auth"
        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(actualServiceType, address)

            reply = Auth.Client.validate(pid, token)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

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
            |> send_resp(503, 'unavailable')
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  get "/users/:id" do
    # Extract from cache if present
    case Redix.command(:redix, ["GET", "user" <> id]) do
      {:ok, nil} ->
        id = String.to_integer(id)

        serviceType = "school"
        actualServiceType = "auth"

        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(actualServiceType, address)

            reply = Auth.Client.get_user(pid, id)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

              {:ok, user} ->
                jsonResp = Protobuf.JSON.encode(user)

                case jsonResp do
                  {:ok, jsonResp} ->
                    # Put in cache
                    if user.status != 404 do
                      Redix.command(:redix, [
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

          _ ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')
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
        serviceType = "school"
        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(serviceType, address)
            reply = School.Client.create_school(pid, body)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

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
            |> send_resp(503, 'unavailable')
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
        serviceType = "school"
        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(serviceType, address)
            reply = School.Client.create_class(pid, body)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

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
            |> send_resp(503, 'unavailable')
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
        serviceType = "school"
        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(serviceType, address)
            reply = School.Client.create_student(pid, body)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

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
            |> send_resp(503, 'unavailable')
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  get "/class/:id" do
    # Extract from cache if present
    case Redix.command(:redix, ["GET", "class" <> id]) do
      {:ok, nil} ->
        id = String.to_integer(id)

        serviceType = "school"
        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(serviceType, address)
            reply = School.Client.get_class(pid, id)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

              {:ok, class} ->
                jsonResp = Protobuf.JSON.encode(class)

                case jsonResp do
                  {:ok, jsonResp} ->
                    if class.status != 404 do
                      Redix.command(:redix, [
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

          _ ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')
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
        serviceType = "course"
        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(serviceType, address)
            reply = Course.Client.create_course(pid, body)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

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
            |> send_resp(503, 'unavailable')
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
    end
  end

  get "/course/:id" do
    case Redix.command(:redix, ["GET", "course" <> id]) do
      {:ok, nil} ->
        Logger.info("No course data found in cache")
        id = String.to_integer(id)

        serviceType = "course"
        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(serviceType, address)
            reply = Course.Client.get_course(pid, id)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

              {:ok, course} ->
                jsonResp = Protobuf.JSON.encode(course)

                case jsonResp do
                  {:ok, jsonResp} ->
                    if course.status != 404 do
                      Redix.command(:redix, [
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

          _ ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(503, 'unavailable')
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
        serviceType = "course"
        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(serviceType, address)
            reply = Course.Client.create_lesson(pid, body)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

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
            |> send_resp(503, 'unavailable')
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
        serviceType = "course"
        %{"service" => address, "status" => status} = SDClient.loadBalanceService(serviceType)

        case status do
          200 ->
            pid = SDClient.getProcessPid(serviceType, address)
            reply = Course.Client.create_mark(pid, body)

            case reply do
              {:error, %GRPC.RPCError{message: "timeout when waiting for server", status: _}} ->
                conn
                |> put_resp_header("Connection", "close")
                |> send_resp(408, "Request timeout")

              {:error, error} ->
                send_resp(conn, 500, error)

              {:ok, protoReply} ->
                jsonResp = Protobuf.JSON.encode(protoReply)
                Logger.info("Removing info of course #{courseId} from cache")
                Redix.command(:redix, ["DEL", "course" <> courseId])

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
            |> send_resp(503, 'unavailable')
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, '')
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
