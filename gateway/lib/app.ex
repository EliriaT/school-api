defmodule APIGateway do
  use Application
  require Logger

  def start(_type, _args) do

    childrenSD = [{SDClient, []}]
    {:ok, pid} = Supervisor.start_link(childrenSD, strategy: :one_for_one)

    %{"replicas" => schoolServices, "status" => status} = SDClient.getReplicas("school")
    %{"replicas" => courseServices, "status" => status} = SDClient.getReplicas("course")

    children =
      Enum.reduce(schoolServices, [], fn address, acc ->
        {:ok, auth_conn} = GRPC.Stub.connect(address)
        Logger.info("Gateway connected to Auth Service at #{address}")

        {:ok, school_conn} = GRPC.Stub.connect(address)
        Logger.info("Gateway connected to School Service at #{address}")

        [
          %{
            id: UUID.uuid1(),
            start: {Auth.Client, :start_link, [auth_conn]}
          },
          %{
            id: UUID.uuid1(),
            start: {School.Client, :start_link, [school_conn]}
          }
          | acc
        ]
      end)

    children =
      Enum.reduce(courseServices, children, fn address, acc ->
        {:ok, course_conn} = GRPC.Stub.connect(address)
        Logger.info("Gateway connected to Course Service at #{address}")

        [
          %{
            id: UUID.uuid1(),
            start: {Course.Client, :start_link, [course_conn]}
          }
          | acc
        ]
      end)

    children = [
      {Plug.Cowboy, scheme: :http, plug: Gateway, options: [port: 8080]},
      {Redix, host: "localhost", name: :redix, port: 6379}
      | children
    ]

    opts = [strategy: :one_for_one, name: Gateway.Supervisor]
    Logger.info("Gateway started.")
    Supervisor.start_link(children, opts)
  end
  
end
