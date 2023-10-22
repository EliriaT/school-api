defmodule SDClient do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, socket} = :gen_tcp.connect('localhost', 4040, [:binary, packet: 0, active: false, reuseaddr: true])
    Logger.info("Gateway connected to service discovery")
    {:ok, socket}
  end

  def getReplicas(type) do
    GenServer.call(__MODULE__, {:get_replicas, type})
  end

  def loadBalanceService(type) do
    GenServer.call(__MODULE__, {:load_balance, type})
  end

  def getProcessPid(type,address) do
    case Registry.lookup(PidRegistry, "#{type}:#{address}") do
      [] ->
        false

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
