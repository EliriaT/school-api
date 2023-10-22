defmodule APIGateway do
  use Application
  require Logger

  def start(_type, _args) do
    childrenSD = [{SDClient, []}]
    {:ok, pid} = Supervisor.start_link(childrenSD, strategy: :one_for_one)

    {:ok, _} = Registry.start_link(keys: :unique, name: PidRegistry)

    %{"replicas" => schoolServices, "status" => status} = SDClient.getReplicas("school")
    %{"replicas" => courseServices, "status" => status} = SDClient.getReplicas("course")

    children =
      Enum.reduce(schoolServices, [], fn address, acc ->
        {:ok, auth_conn} = GRPC.Stub.connect(address)
        Logger.info("Gateway connected to Auth Service at #{address}")
        authName = UUID.uuid1()

        {:ok, school_conn} = GRPC.Stub.connect(address)
        Logger.info("Gateway connected to School Service at #{address}")
        schoolName = UUID.uuid1()

        [
          %{
            id: authName,
            start: {Auth.Client, :start_link, [auth_conn, "auth:#{address}"]}
          },
          %{
            id: schoolName,
            start: {School.Client, :start_link, [school_conn, "school:#{address}"]}
          }
          | acc
        ]
      end)

    children =
      Enum.reduce(courseServices, children, fn address, acc ->
        {:ok, course_conn} = GRPC.Stub.connect(address)
        Logger.info("Gateway connected to Course Service at #{address}")
        courseName = UUID.uuid1()

        [
          %{
            id: courseName,
            start: {Course.Client, :start_link, [course_conn, "course:#{address}"]}
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
