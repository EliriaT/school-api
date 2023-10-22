defmodule School.Client do
  use GenServer
  require Logger

  @timeout 1000
  @gen_server_timeout 3000

  # def start_link(conn, uuidName) do
  #   name = {:via, Registry, {PidRegistry, uuidName}}
  #   GenServer.start_link(__MODULE__, conn, name: name)
  # end

  # def init(conn) do
  #   {:ok, conn}
  # end

  # def check_health(pid) do
  #   GenServer.call(pid, {:check_health},  @gen_server_timeout)
  # end

  # def handle_call({:check_health}, _from, conn) do
  #   request = %School.HealthRequest{check: true}
  #   resp = conn |> School.SchoolService.Stub.check_health(request, timeout: @timeout)
  #   {:reply, resp, conn}
  # end

  def check_health(address) do
    case GRPC.Stub.connect(address) do
      {:ok, channel} ->
        request = %School.HealthRequest{check: true}
        resp = School.SchoolService.Stub.check_health(channel, request, timeout: @timeout)

        GRPC.Stub.disconnect(channel)

        case resp do
          {:error, _error} ->
            {:error, :unhealthy}

          {:ok, protoReply} ->
            if protoReply.healthy == true do
              {:ok, true}
            else
              {:error, :unhealthy}
            end
        end

      {:error, error} ->
        {:error, error}
    end
  end
end
