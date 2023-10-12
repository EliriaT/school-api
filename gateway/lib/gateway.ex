# elixir --no-halt lib/check5/main.ex
# iex -S mix run
# Gateway.start(nil,nil)
# protoc --elixir_out=plugins=grpc:./lib/proto ./lib/proto/*.proto

defmodule Gateway do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Main.Router, options: [port: 8080]},
    ]

    opts = [strategy: :one_for_one, name: Gateway.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Main.Router do
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

  get "/class" do
    send_resp(conn, 200, "class")
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, "Not Found")
  end
end