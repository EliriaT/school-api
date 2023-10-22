defmodule Course.CourseRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :name, 1, type: :string
  field :teacherId, 2, type: :int64
  field :classId, 3, type: :int64
end

defmodule Course.LessonRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :name, 1, type: :string
  field :courseId, 2, type: :int64
  field :startHour, 3, type: :string
  field :endHour, 4, type: :string
  field :weekDay, 5, type: :string
  field :classRoom, 6, type: :string
end

defmodule Course.MarkRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :courseId, 1, type: :int64
  field :markDate, 2, type: :string
  field :isAbsent, 3, type: :bool
  field :mark, 4, type: :int32
  field :studentId, 5, type: :int64
end

defmodule Course.CourseCreateResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :status, 1, type: :int64
  field :error, 2, type: :string
end

defmodule Course.Course do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :id, 1, type: :int64
  field :name, 2, type: :string
  field :teacherId, 3, type: :int64
  field :classId, 4, type: :int64
  field :marks, 5, repeated: true, type: Course.Mark
end

defmodule Course.Mark do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :id, 1, type: :int64
  field :courseId, 2, type: :int64
  field :markDate, 3, type: :string
  field :isAbsent, 4, type: :bool
  field :mark, 5, type: :int32
  field :studentId, 6, type: :int64
end

defmodule Course.CourseResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :status, 1, type: :int64
  field :error, 2, type: :string
  field :data, 3, type: Course.Course
end

defmodule Course.HealthRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :check, 1, type: :bool
end

defmodule Course.HealthResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :healthy, 1, type: :bool
end

defmodule Course.CourseID do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :id, 1, type: :int64
end

defmodule Course.CourseService.Service do
  @moduledoc false

  use GRPC.Service, name: "course.CourseService", protoc_gen_elixir_version: "0.12.0"

  rpc :CreateCourse, Course.CourseRequest, Course.CourseCreateResponse

  rpc :GetCourse, Course.CourseID, Course.CourseResponse

  rpc :CreateLesson, Course.LessonRequest, Course.CourseCreateResponse

  rpc :CreateMark, Course.MarkRequest, Course.CourseCreateResponse

  rpc :CheckHealth, Course.HealthRequest, Course.HealthResponse
end

defmodule Course.CourseService.Stub do
  @moduledoc false

  use GRPC.Stub, service: Course.CourseService.Service
end