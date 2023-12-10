defmodule Auth.EntityID do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:id, 1, type: :int64)
end

defmodule Auth.UserResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: :int64)
  field(:error, 2, type: :string)
  field(:data, 3, type: Auth.User)
end

defmodule Auth.User do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:id, 1, type: :int64)
  field(:email, 2, type: :string)
  field(:name, 3, type: :string)
  field(:schoolId, 4, type: :int64)
  field(:roleId, 5, type: :int64)
end

defmodule Auth.RegisterRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:email, 1, type: :string)
  field(:password, 2, type: :string)
  field(:name, 3, type: :string)
  field(:schoolId, 4, type: :int64)
  field(:roleId, 5, type: :int64)
end

defmodule Auth.RegisterResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: :int64)
  field(:error, 2, type: :string)
end

defmodule Auth.LoginRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:email, 1, type: :string)
  field(:password, 2, type: :string)
end

defmodule Auth.LoginResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: :int64)
  field(:error, 2, type: :string)
  field(:token, 3, type: :string)
end

defmodule Auth.ValidateRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:token, 1, type: :string)
end

defmodule Auth.ValidateResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: :int64)
  field(:error, 2, type: :string)
  field(:userId, 3, type: :int64)
end

defmodule Auth.AuthService.Service do
  @moduledoc false

  use GRPC.Service, name: "auth.AuthService", protoc_gen_elixir_version: "0.12.0"

  rpc(:GetUser, Auth.EntityID, Auth.UserResponse)

  rpc(:Register, Auth.RegisterRequest, Auth.RegisterResponse)

  rpc(:Login, Auth.LoginRequest, Auth.LoginResponse)

  rpc(:Validate, Auth.ValidateRequest, Auth.ValidateResponse)
end

defmodule Auth.AuthService.Stub do
  @moduledoc false

  use GRPC.Stub, service: Auth.AuthService.Service
end
