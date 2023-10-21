defmodule APIGateway do
  use Application
  require Logger

  def start(_type, _args) do
    case areServicesLive() do
      false ->
        Logger.info("Gateway could not start.")
        :fail

      {{:ok, auth_conn}, {:ok, school_conn}, {:ok, course_conn}} ->
        children = [
          {Plug.Cowboy, scheme: :http, plug: Gateway, options: [port: 8080]},
          %{
            id: Auth.Client,
            start: {Auth.Client, :start_link, [auth_conn]}
          },
          %{
            id: School.Client,
            start: {School.Client, :start_link, [school_conn]}
          },
          %{
            id: Course.Client,
            start: {Course.Client, :start_link, [course_conn]}
          },
          {Redix, host: "localhost", name: :redix, port: 6379},
        ]

        opts = [strategy: :one_for_one, name: Gateway.Supervisor]
        Logger.info("Gateway started.")
        Supervisor.start_link(children, opts)
    end

    # {:ok, auth_conn} = GRPC.Stub.connect("localhost:8081")
    # Logger.info("Gateway connected to Auth Service")

    # children = [
    #   {Plug.Cowboy, scheme: :http, plug: Gateway, options: [port: 8080]},
    #   %{
    #     id: Auth.Client,
    #     start: {Auth.Client, :start_link, [auth_conn]}
    #   }
    # ]

    # opts = [strategy: :one_for_one, name: Gateway.Supervisor]
    # Logger.info("Gateway started.")
    # Supervisor.start_link(children, opts)
  end

  defp areServicesLive() do
    conn1 = connectToAuthService()
    conn2 = connectToSchoolService()
    conn3 = connectToCourseService()

    if conn1 == false || conn2 == false || conn3 == false do
      false
    else
      {conn1, conn2, conn3}
    end
  end

  defp connectToAuthService() do
    auth_conn =
      case GRPC.Stub.connect("localhost:8081") do
        {:ok, auth_conn} ->
          Logger.info("Gateway connected to Auth Service")
          {:ok, auth_conn}

        {:error, error} ->
          Logger.info("Gateway could not connect to Auth Service. Reason: " <> to_string(error))
          false
      end

    auth_conn
  end

  defp connectToSchoolService() do
    school_conn =
      case GRPC.Stub.connect("localhost:8081") do
        {:ok, school_conn} ->
          Logger.info("Gateway connected School Service")
          {:ok, school_conn}

        {:error, error} ->
          Logger.info("Gateway could not connect to School Service. Reason: " <> to_string(error))
          false
      end

    school_conn
  end

  defp connectToCourseService() do
    course_conn =
      case GRPC.Stub.connect("localhost:8082") do
        {:ok, course_conn} ->
          Logger.info("Gateway connected Course Service")
          {:ok, course_conn}

        {:error, error} ->
          Logger.info("Gateway could not connect to Course Service. Reason: " <> to_string(error))
          false
      end

    course_conn
  end
end
