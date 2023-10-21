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
            |> send_resp(200, jsonResp)

          {:error, _} ->
            send_resp(conn, 500, "json encoding failed")
        end

      _ ->
        send_resp(conn, 500, "")
    end
  end

  post "/users" do

  end

  post "/users/login" do

  end

  post "/users/token" do

  end

  post "/schools" do

  end

  post "/class" do

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
            |> send_resp(200, jsonResp)

          {:error, _} ->
            send_resp(conn, 500, "json encoding failed")
        end

      _ ->
        send_resp(conn, 500, "")
    end
  end

  # course service

  post "/course" do

  end

  get  "/course/:id" do
    id = String.to_integer(id)
    reply = Course.Client.get_course(id)

    case reply do
      {:error, error} ->
        send_resp(conn, 500, error)

      {:ok, class} ->
        jsonResp = Protobuf.JSON.encode(class)

        case jsonResp do
          {:ok, jsonResp} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, jsonResp)

          {:error, _} ->
            send_resp(conn, 500, "json encoding failed")
        end

      _ ->
        send_resp(conn, 500, "")
    end
  end

  post  "/lesson" do

  end

  post  "/mark" do

  end


  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, "Not Found")
  end
end
