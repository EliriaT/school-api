defmodule ETSRegistry do
  use GenServer
  require Logger

  @time 1000

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ets.new(:registry, [:set, :public]), name: __MODULE__)
  end

  def init(ets_table) do
    # schedule_work()

    {:ok, ets_table}
  end

  defp schedule_work do
    Process.send_after(self(), :work, @time)
  end

  def registerService(type, address) do
    GenServer.cast(__MODULE__, {:register, type, address})
  end

  def getReplicas(type) do
    GenServer.call(__MODULE__, {:get_replicas, type})
  end

  def loadBalanceService(type) do
    GenServer.call(__MODULE__, {:load_balance, type})
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
    userList =
      case :ets.lookup(ets_table, type) do
        [] -> []
        [{_key, old_list}] -> old_list
      end

    {:reply, userList, ets_table}
  end

  def handle_call({:load_balance, type}, _from, ets_table) do
    userList =
      case :ets.lookup(ets_table, type) do
        [] -> []
        [{_key, old_list}] -> old_list
      end

    service = if Enum.empty?(userList), do: "", else: Enum.random(userList)
    {:reply, service, ets_table}
  end

  def handle_info(:work, ets_table) do
    schedule_work()

    # aici se poate de invalidat pidul
    # odata la 8 secunde verific ca toate serviciile sa aiba un ping recent cu cel putin 8 secunde in urma
    # daca este un serviciu cu ping tare de demult, il scot din service

    # fac handle info asincron odata la 2 secunde for healthcheck

    {:noreply, ets_table}
  end
end
