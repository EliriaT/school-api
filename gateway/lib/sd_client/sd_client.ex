defmodule SDClient do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    domain = System.get_env("SD_DOMAIN", "localhost")
    port = System.get_env("SD_PORT", "4040")
    domain = String.to_charlist(domain)
    port = String.to_integer(port)

    {:ok, socket} =
      :gen_tcp.connect(domain, port, [:binary, packet: 0, active: false, reuseaddr: true])

    Logger.info("Gateway connected to service discovery")
    {:ok, socket}
  end

  def getReplicas(type) do
    GenServer.call(__MODULE__, {:get_replicas, type}, 10000)
  end

  def loadBalanceService(type) do
    GenServer.call(__MODULE__, {:load_balance, type}, 10000)
  end

  def getProcessPid(type, address) do
    case Registry.lookup(PidRegistry, "#{type}:#{address}") do
      #  in case there is no grpc client for that addres, then create dinamically a new one!
      [] ->
        child =
          cond do
            type == "school" ->
              schoolName = UUID.uuid1()
              {:ok, school_conn} = GRPC.Stub.connect(address)
              Logger.info("Gateway connected to School Service at #{address}")

              %{
                id: schoolName,
                start: {School.Client, :start_link, [school_conn, "school:#{address}"]}
              }

            type == "course" ->
              courseName = UUID.uuid1()
              {:ok, course_conn} = GRPC.Stub.connect(address)
              Logger.info("Gateway connected to Course Service at #{address}")

              %{
                id: courseName,
                start: {Course.Client, :start_link, [course_conn, "course:#{address}"]}
              }

            type == "auth" ->
              authName = UUID.uuid1()
              {:ok, auth_conn} = GRPC.Stub.connect(address)
              Logger.info("Gateway connected to Auth Service at #{address}")

              %{
                id: authName,
                start: {Auth.Client, :start_link, [auth_conn, "auth:#{address}"]}
              }
          end

        {:ok, clientPid} = DynamicSupervisor.start_child(DynamicServices.Supervisor, child)

        clientPid

      [{pid, _value}] ->
        pid
    end
  end

  def handle_call({:get_replicas, type}, _from, socket) do
    request = %{"replicas_type" => type}

    :ok = :gen_tcp.send(socket, Jason.encode!(request))

    reply =
      case :gen_tcp.recv(socket, 0) do
        {:ok, line} ->
          line = String.downcase(line)

          case Jason.decode(line) do
            {:ok, map} ->
              map

            {:error, error} ->
              IO.puts(error)
              :gen_tcp.close(socket)
              Process.exit(self(), :error)
          end

        {:error, :closed} ->
          IO.puts("Service Discovery closed socket")
          :gen_tcp.close(socket)
          Process.exit(self(), :error)
      end

    {:reply, reply, socket}
  end

  def handle_call({:load_balance, type}, _from, socket) do
    request = %{"service_type" => type}

    :ok = :gen_tcp.send(socket, Jason.encode!(request))

    reply =
      case :gen_tcp.recv(socket, 0) do
        {:ok, line} ->
          line = String.downcase(line)

          case Jason.decode(line) do
            {:ok, map} ->
              map

            {:error, error} ->
              IO.puts(error)
              :gen_tcp.close(socket)
              Process.exit(self(), :error)
          end

        {:error, :closed} ->
          IO.puts("Service Discovery closed socket")
          :gen_tcp.close(socket)
          Process.exit(self(), :error)
      end

    {:reply, reply, socket}
  end
end
