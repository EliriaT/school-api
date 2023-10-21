defmodule Auth.Client do
  use GenServer
  require Logger

  def start_link(conn) do
    GenServer.start_link(__MODULE__, conn, name: __MODULE__)
  end

  def init(conn) do
    {:ok, conn}
  end

  def get_user(id) do
    GenServer.call(__MODULE__, {:get_user, id})
  end

  def validate(token) do
    GenServer.call(__MODULE__, {:token_check, token})
  end

  def login(loginReq) do
    GenServer.call(__MODULE__, {:login, loginReq})
  end

  def register(registerReq) do
    GenServer.call(__MODULE__, {:register, registerReq})
  end

  def handle_call({:get_user, id}, _from, conn) do
    # Logger.info(conn)
    request = %Auth.EntityID{id: id}
    resp = conn |> Auth.AuthService.Stub.get_user(request)
    {:reply, resp, conn}
  end

  def handle_call({:login, %{"email" => email, "password" => password}}, _from, conn) do
    request = %Auth.LoginRequest{email: email, password: password}
    resp = conn |> Auth.AuthService.Stub.login(request)
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

    resp = conn |> Auth.AuthService.Stub.register(request)
    {:reply, resp, conn}
  end

  def handle_call({:token_check, token}, _from, conn) do
    request = %Auth.ValidateRequest{token: token}
    resp = conn |> Auth.AuthService.Stub.validate(request)
    {:reply, resp, conn}
  end
end
