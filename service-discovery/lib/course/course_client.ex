defmodule Course.Client do
  use GenServer
  require Logger

  @timeout 4000
  @gen_server_timeout 10000

  def check_health(address) do
    case GRPC.Stub.connect(address) do
      {:ok, channel} ->
        request = %Course.HealthRequest{check: true}
        resp = Course.CourseService.Stub.check_health(channel, request, timeout: @timeout)

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
