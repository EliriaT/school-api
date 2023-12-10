defmodule Auth.Client do
  use GenServer
  require Logger

  @timeout 4000
  @gen_server_timeout 10000

  @serviceType "school"
  @actualServiceType "auth"

  def start_link(conn, uuidName) do
    name = {:via, Registry, {PidRegistry, uuidName}}
    GenServer.start_link(__MODULE__, conn, name: name)
  end

  def init(conn) do
    {:ok, conn}
  end

  def get_user(id, 2) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)
    Logger.info("Too many reroutes happened")

    case status do
      200 ->
        pid = SDClient.getProcessPid(@actualServiceType, address)
        GenServer.call(pid, {:get_user, id}, @gen_server_timeout)

      _ ->
        {:unavailable}
    end
  end

  def get_user(id, rerouteCounter) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)

    case status do
      200 ->
        pid = SDClient.getProcessPid(@actualServiceType, address)
        reply = GenServer.call(pid, {:get_user, id}, @gen_server_timeout)

        case reply do
          {:error, error} ->
            # inseamneaza in circuit breaker

            # increment reroute counter
            rerouteCounter = rerouteCounter + 1
            Logger.info("Rerouting happened")

            # reroute
            Auth.Client.get_user(id, rerouteCounter)

          {:ok, user} ->
            {:ok, user}
        end

      _ ->
        {:unavailable}
    end
  end

  def validate(token, 2) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)
    Logger.info("Too many reroutes happened")

    case status do
      200 ->
        pid = SDClient.getProcessPid(@actualServiceType, address)
        GenServer.call(pid, {:token_check, token}, @gen_server_timeout)

      _ ->
        {:unavailable}
    end
  end

  def validate(token, rerouteCounter) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)

    case status do
      200 ->
        pid = SDClient.getProcessPid(@actualServiceType, address)
        reply = GenServer.call(pid, {:token_check, token}, @gen_server_timeout)

        case reply do
          {:error, error} ->
            # inseamneaza in circuit breaker

            # increment reroute counter
            rerouteCounter = rerouteCounter + 1
            Logger.info("Rerouting happened")

            # reroute
            Auth.Client.validate(token, rerouteCounter)

          {:ok, user} ->
            {:ok, user}
        end

      _ ->
        {:unavailable}
    end
  end

  def login(loginReq, 2) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)
    Logger.info("Too many reroutes happened")

    case status do
      200 ->
        pid = SDClient.getProcessPid(@actualServiceType, address)
        GenServer.call(pid, {:login, loginReq}, @gen_server_timeout)

      _ ->
        {:unavailable}
    end
  end

  def login(loginReq, rerouteCounter) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)

    case status do
      200 ->
        pid = SDClient.getProcessPid(@actualServiceType, address)
        reply = GenServer.call(pid, {:login, loginReq}, @gen_server_timeout)

        case reply do
          {:error, error} ->
            # inseamneaza in circuit breaker

            # increment reroute counter
            rerouteCounter = rerouteCounter + 1
            Logger.info("Rerouting happened")

            # reroute
            Auth.Client.login(loginReq, rerouteCounter)

          {:ok, user} ->
            {:ok, user}
        end

      _ ->
        {:unavailable}
    end
  end

  # on 2 redirect send response as it is
  def register(registerReq, 2) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)
    Logger.info("Too many reroutes happened")

    case status do
      200 ->
        pid = SDClient.getProcessPid(@actualServiceType, address)
        GenServer.call(pid, {:register, registerReq}, @gen_server_timeout)

      _ ->
        {:unavailable}
    end
  end

  # eu pot aici sa fac circuit breaker : )
  def register(registerReq, rerouteCounter) do
    %{"service" => address, "status" => status} = SDClient.loadBalanceService(@serviceType)

    case status do
      200 ->
        pid = SDClient.getProcessPid(@actualServiceType, address)
        reply = GenServer.call(pid, {:register, registerReq}, @gen_server_timeout)

        case reply do
          {:error, error} ->
            # inseamneaza in circuit breaker

            # increment reroute counter
            rerouteCounter = rerouteCounter + 1
            Logger.info("Rerouting happened")

            # reroute
            Auth.Client.register(registerReq, rerouteCounter)

          {:ok, user} ->
            {:ok, user}
        end

      _ ->
        {:unavailable}
    end
  end

  def handle_call({:get_user, id}, _from, conn) do
    # Logger.info(conn)
    request = %Auth.EntityID{id: id}
    resp = conn |> Auth.AuthService.Stub.get_user(request, timeout: @timeout)
    {:reply, resp, conn}
  end

  def handle_call({:login, %{"email" => email, "password" => password}}, _from, conn) do
    request = %Auth.LoginRequest{email: email, password: password}
    resp = conn |> Auth.AuthService.Stub.login(request, timeout: @timeout)
    {:reply, resp, conn}
  end

  def handle_call(
        {:register,
         %{
           "email" => email,
           "password" => password,
           "name" => name,
           "schoolId" => schoolId,
           "roleId" => roleId
         }},
        _from,
        conn
      ) do
    request = %Auth.RegisterRequest{
      email: email,
      password: password,
      name: name,
      schoolId: String.to_integer(schoolId),
      roleId: String.to_integer(roleId)
    }

    resp = conn |> Auth.AuthService.Stub.register(request, timeout: @timeout)
    {:reply, resp, conn}
  end

  def handle_call({:token_check, token}, _from, conn) do
    request = %Auth.ValidateRequest{token: token}
    resp = conn |> Auth.AuthService.Stub.validate(request, timeout: @timeout)
    {:reply, resp, conn}
  end
end
