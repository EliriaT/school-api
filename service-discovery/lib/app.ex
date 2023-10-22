defmodule ServiceDiscovery do
  use Application
  require Logger

  def start(_type, _args) do
    port = 4040

    children = [
      {Task.Supervisor, name: TCPConnections.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> TCPServer.accept(port) end}, restart: :permanent),
      {ETSRegistry, []}
    ]

    opts = [strategy: :one_for_one, name: :service_discovery]
    Logger.info("Service Discovery started....")
    Supervisor.start_link(children, opts)
  end

end
