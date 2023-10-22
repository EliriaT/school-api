defmodule TCPServer do
  require Logger

  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available, in other words, the read is synchronous
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes

    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: 0, active: false, reuseaddr: true])

    Logger.info("Server  accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    # each tcp connection is a separate concurrent actor
    {:ok, pid} =
      Task.Supervisor.start_child(TCPConnections.TaskSupervisor, fn ->
        SvcRegistry.serveLoop(client)
      end)

    # # this ensures that messages will be send to process pid, but not to the actor that accepted the socket connection. Also ensures that the acceptor
    # # will not bring down the clients on crash. Sockets are not tied to the process that accepted them
    # # if the tcp acceptor server crashes, the connections are not crashed
    # # if connection pid crashes, acceptor does not crashes
    :ok = :gen_tcp.controlling_process(client, pid)

    loop_acceptor(socket)
  end

  # defp serve(socket) do
  #   socket
  #   |> read_line()
  #   |> write_line(socket)

  #   serve(socket)
  # end

  def read_line(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} = resp ->
        resp

      {:error, _} = err ->
        err
    end
  end

  def write_line({:error, :closed}, _socket) do
    # The connection was closed, exit politely
    IO.puts("Connection on process #{inspect(self())} closed by client")
    exit(:shutdown)
  end

  def write_line({:error, error}, socket) do
    # Unknown error; write to the client and exit
    :gen_tcp.send(socket, "ERROR #{inspect(error)}\r\n")
    exit(error)
  end

  def write_line({:ok, line}, socket) do
    :gen_tcp.send(socket, line)
  end
end
