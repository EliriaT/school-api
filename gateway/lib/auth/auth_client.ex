defmodule Auth.Client do
  use GenServer
  require Logger

  @timeout 4000

  @gen_server_timeout 10000

  def start_link(conn) do
    GenServer.start_link(__MODULE__, conn, name: __MODULE__)
  end

  def init(conn) do
    {:ok, conn}
  end

  def get_user(id) do
    GenServer.call(__MODULE__, {:get_user, id}, @gen_server_timeout)
  end

  def validate(token) do
    GenServer.call(__MODULE__, {:token_check, token}, @gen_server_timeout)
  end

  def login(loginReq) do
    GenServer.call(__MODULE__, {:login, loginReq}, @gen_server_timeout)
  end

  def register(registerReq) do
    GenServer.call(__MODULE__, {:register, registerReq}, @gen_server_timeout)
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
