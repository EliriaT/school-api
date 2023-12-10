defmodule School.SchoolRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:name, 1, type: :string)
end

defmodule School.CreateResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: :int64)
  field(:error, 2, type: :string)
end

defmodule School.ClassRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:name, 1, type: :string)
  field(:headTeacher, 2, type: :int64)
  field(:schoolId, 3, type: :int64)
end

defmodule School.Class do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:id, 1, type: :int64)
  field(:name, 2, type: :string)
  field(:headTeacher, 3, type: :int64)
  field(:schoolId, 4, type: :int64)
end

defmodule School.ClassResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: :int64)
  field(:error, 2, type: :string)
  field(:data, 3, type: School.Class)
end

defmodule School.StudentRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:userID, 1, type: :int64)
  field(:classID, 2, type: :int64)
end

defmodule School.HealthRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:check, 1, type: :bool)
end

defmodule School.HealthResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:healthy, 1, type: :bool)
end

defmodule School.ID do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:id, 1, type: :int64)
end

defmodule School.SchoolService.Service do
  @moduledoc false

  use GRPC.Service, name: "school.SchoolService", protoc_gen_elixir_version: "0.12.0"

  rpc(:CreateSchool, School.SchoolRequest, School.CreateResponse)

  rpc(:CreateClass, School.ClassRequest, School.CreateResponse)

  rpc(:GetClass, School.ID, School.ClassResponse)

  rpc(:CreateStudent, School.StudentRequest, School.CreateResponse)

  rpc(:CheckHealth, School.HealthRequest, School.HealthResponse)
end

defmodule School.SchoolService.Stub do
  @moduledoc false

  use GRPC.Stub, service: School.SchoolService.Service
end
