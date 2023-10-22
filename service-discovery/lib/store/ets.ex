defmodule ETSRegistry do
  use GenServer
  require Logger

  @time 2000

  @timeout 10000

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ets.new(:registry, [:set, :public, :named_table]), name: __MODULE__)
  end

  def init(ets_table) do
    ping_services()

    {:ok, ets_table}
  end

  defp ping_services do
    Process.send_after(self(), :ping, @time)
  end

  def registerService(type, address) do
    GenServer.cast(__MODULE__, {:register, type, address})
  end

  def getReplicas(type) do
    GenServer.call(__MODULE__, {:get_replicas, type},@timeout)
  end

  def loadBalanceService(type) do
    GenServer.call(__MODULE__, {:load_balance, type}, @timeout)
  end

  def handle_cast({:register, type, address}, ets_table) do
    replicaList =
      case :ets.lookup(ets_table, type) do
        [] -> []
        [{_key, old_list}] -> old_list
      end

    :ets.insert(
      ets_table,
      {type,
       [
         address | replicaList
       ]}
    )

    Logger.info("Service #{type} located at #{address} succesfully registered. ")

    {:noreply, ets_table}
  end

  def handle_call({:get_replicas, type}, _from, ets_table) do
    replicas =
      case :ets.lookup(ets_table, type) do
        [] -> []
        [{_key, old_list}] -> old_list
      end

    {:reply, replicas, ets_table}
  end

  def handle_call({:load_balance, type}, _from, ets_table) do
    userList =
      case :ets.lookup(ets_table, type) do
        [] -> []
        [{_key, old_list}] -> old_list
      end

    service =
      if Enum.empty?(userList) do
        ""
      else
        [h | t] = userList

        :ets.insert(
          ets_table,
          {type, t ++ [h]}
        )

        h
      end

    {:reply, service, ets_table}
  end

  def handle_info(:ping, ets_table) do
    schoolReplicas = get_replicas_list("school")
    ping(schoolReplicas, "school")

    courseReplicas = get_replicas_list("course")
    ping(courseReplicas, "course")

    ping_services()
    {:noreply, ets_table}
  end

  defp ping([h | t], type) do
    pint_n_types(3, h, type)

    ping(t, type)
  end

  defp ping([], type) do
  end

  defp pint_n_types(0, address, type) do
    replicas = get_replicas_list(type)
    replicas = List.delete(replicas, address)

    Logger.info("Service #{type} at #{address} is unreachable. Removed from service list.")
    :ets.insert(:registry, {type, replicas})
  end

  defp pint_n_types(n, address, type) do
    case type do
      "school" ->
        status = School.Client.check_health(address)

        case status do
          {:ok, true} ->
            :good

          {:error, _error} ->
            pint_n_types(n - 1, address, type)
        end

      "course" ->
        status = Course.Client.check_health(address)

        case status do
          {:ok, true} ->
            :good

          {:error, _error} ->
            pint_n_types(n - 1, address, type)
        end
    end
  end

  defp get_replicas_list(type) do
    case :ets.lookup(:registry, type) do
      [] -> []
      [{_key, old_list}] -> old_list
    end
  end
end
