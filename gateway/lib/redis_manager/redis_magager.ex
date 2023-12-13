defmodule RedisManager do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    IO.puts("Redis manager started")
    schedule_ping()

    {:ok, %{redix1: true, redix2: true, redix3: true}}
  end

  def handle_info(:ping, state) do
    state =
      case Redix.command(:redix1, ["PING"]) do
        {:ok, "PONG"} ->
          # adding node if it was previously deleted
          case state do
            %{redix1: false, redix2: _, redix3: _} ->
              HashRing.Managed.add_node(:myring, :redix1)
              Map.merge(state, %{redix1: true})

            _ ->
              state
          end

        {:error, reason} ->
          # removing node if it unreachable
          HashRing.Managed.remove_node(:myring, :redix1)
          IO.puts("Ping unsuccessful to redix1 unsuccesfull. Removing it")
          Map.merge(state, %{redix1: false})
      end

    state =
      case Redix.command(:redix2, ["PING"]) do
        {:ok, "PONG"} ->
          # adding node if it was previously deleted
          case state do
            %{redix1: _, redix2: false, redix3: _} ->
              HashRing.Managed.add_node(:myring, :redix2)
              Map.merge(state, %{redix2: true})

            _ ->
              state
          end

        {:error, reason} ->
          # removing node if it unreachable
          HashRing.Managed.remove_node(:myring, :redix2)
          IO.puts("Ping unsuccessful to redix2 unsuccesfull. Removing it")
          Map.merge(state, %{redix2: false})
      end

    state =
      case Redix.command(:redix3, ["PING"]) do
        {:ok, "PONG"} ->
          # adding node if it was previously deleted
          case state do
            %{redix1: _, redix2: _, redix3: false} ->
              HashRing.Managed.add_node(:myring, :redix3)
              Map.merge(state, %{redix3: true})

            _ ->
              state
          end

        {:error, reason} ->
          # removing node if it unreachable
          HashRing.Managed.remove_node(:myring, :redix3)
          IO.puts("Ping unsuccessful to redix3 unsuccesfull. Removing it")
          Map.merge(state, %{redix3: false})
      end

      IO.inspect(state)

    schedule_ping()
    {:noreply, state}
  end

  defp schedule_ping do
    Process.send_after(__MODULE__, :ping, 2000)
  end
end
