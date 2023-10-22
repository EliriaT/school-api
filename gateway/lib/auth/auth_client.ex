defmodule Auth.Client do
  use GenServer
  require Logger

  @timeout 4000

  @gen_server_timeout 10000

  def start_link(conn, uuidName) do
    name = {:via, Registry, {PidRegistry, uuidName}}
    GenServer.start_link(__MODULE__, conn, name: name)
  end

  def init(conn) do
    {:ok, conn}
  end

  def get_user(pid, id) do
    GenServer.call(pid, {:get_user, id}, @gen_server_timeout)
  end

  def validate(pid,token) do
    GenServer.call(pid, {:token_check, token}, @gen_server_timeout)
  end

  def login(pid,loginReq) do
    GenServer.call(pid, {:login, loginReq}, @gen_server_timeout)
  end

  def register(pid,registerReq) do
    GenServer.call(pid, {:register, registerReq}, @gen_server_timeout)
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
