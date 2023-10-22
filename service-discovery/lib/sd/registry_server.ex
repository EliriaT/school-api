defmodule SvcRegistry do
  def serveLoop(socket) do
    command =
      case TCPServer.read_line(socket) do
        {:ok, line} ->
          case parseCommands(line) do
            {:ok, command} ->
              runCommand(command, socket)

            {:error, _} = err ->
              err
          end

        {:error, :closed} = err ->
          err

        {:error, _} = err ->
          err
      end

    TCPServer.write_line(command, socket)

    serveLoop(socket)
  end

  # commands are case insensitive
  defp parseCommands(line) when is_binary(line) do
    line = String.downcase(line)

    command =
      case Jason.decode(line) do
        {:ok, map} ->
          map

        {:error, error} ->
          error
      end

    case command do
      %{"type" => type, "address" => address} ->
        {:ok, {:register, type, address}}

      %{"replicas_type" => type} ->
        {:ok, {:get_replicas, type}}

      %{"service_type" => type} ->
        {:ok, {:load_balance, type}}

      %Jason.DecodeError{} ->
        {:error, {:invalid_json, line}}

      _ ->
        # save the command in dead letter channel
        {:error, {:unknown_command, line}}
    end
  end

  defp runCommand(command, socket) do
    case command do
      {:register, type, address} ->
        ETSRegistry.registerService(type, address)
        {:ok, Jason.encode!(%{"status" => 200}) <> "\r\n"}

      {:get_replicas, type} ->
        replicas = ETSRegistry.getReplicas(type)
        {:ok, Jason.encode!(%{"status" => 200, "replicas" => replicas}) <> "\r\n"}

      {:load_balance, type} ->
        replica = ETSRegistry.loadBalanceService(type)
        status = if replica == "", do: 404, else: 200
        reply = %{"status" => status, "service" => replica}

        {:ok, Jason.encode!(reply) <> "\r\n"}

      _ ->
        {:ok, "NOT IMPLEMENTED\r\n"}
    end
  end
end
