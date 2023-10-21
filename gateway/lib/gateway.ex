# elixir --no-halt lib/gateway.ex
# iex -S mix run
# Gateway.start(nil,nil)
# protoc --elixir_out=plugins=grpc:. ./lib/auth/auth.proto

defmodule Gateway do
  use Plug.Router

  plug(Plug.Logger)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  #  @defaults %{"director" => "", "release_year" => 0, "title" => ""}

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
        reply = Auth.Client.register(body)

        case reply do
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
        |> send_resp(400, '')
    end
  end

  post "/users/login" do
    case conn.body_params do
      %{
        "email" => email,
        "password" => password
      } = body ->
        reply = Auth.Client.login(body)

        case reply do
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
        |> send_resp(400, '')
    end
  end

  post "/users/token" do
    case conn.body_params do
      %{
        "token" => token
      } ->
        reply = Auth.Client.validate(token)

        case reply do
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
        |> send_resp(400, '')
    end
  end

  get "/users/:id" do
    id = String.to_integer(id)
    reply = Auth.Client.get_user(id)

    case reply do
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

      _ ->
        send_resp(conn, 500, "")
    end
  end

  post "/schools" do
    case conn.body_params do
      %{
        "name" => name
      } = body ->
        reply = School.Client.create_school(body)

        case reply do
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
        reply = School.Client.create_class(body)

        case reply do
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
        |> send_resp(400, '')
    end
  end

  post "/student" do
    case conn.body_params do
      %{
        "classID" => classID,
        "userID" => userID
      } = body ->
        reply = School.Client.create_student(body)

        case reply do
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
        |> send_resp(400, '')
    end
  end

  get "/class/:id" do
    id = String.to_integer(id)
    reply = School.Client.get_class(id)

    case reply do
      {:error, error} ->
        send_resp(conn, 500, error)

      {:ok, class} ->
        jsonResp = Protobuf.JSON.encode(class)

        case jsonResp do
          {:ok, jsonResp} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(class.status, jsonResp)

          {:error, _} ->
            send_resp(conn, 500, "json encoding failed")
        end

      _ ->
        send_resp(conn, 500, "")
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
        reply = Course.Client.create_course(body)

        case reply do
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
        |> send_resp(400, '')
    end
  end

  get "/course/:id" do
    id = String.to_integer(id)
    reply = Course.Client.get_course(id)

    case reply do
      {:error, error} ->
        send_resp(conn, 500, error)

      {:ok, course} ->
        jsonResp = Protobuf.JSON.encode(course)

        case jsonResp do
          {:ok, jsonResp} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(course.status, jsonResp)

          {:error, _} ->
            send_resp(conn, 500, "json encoding failed")
        end

      _ ->
        send_resp(conn, 500, "")
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
        reply = Course.Client.create_lesson(body)

        case reply do
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
        reply = Course.Client.create_mark(body)

        case reply do
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
        |> send_resp(400, '')
    end
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, "Not Found")
  end
end
