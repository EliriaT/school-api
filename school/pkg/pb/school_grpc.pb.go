// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.2.0
// - protoc             v3.12.4
// source: pkg/pb/school.proto

package pb

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// SchoolServiceClient is the client API for SchoolService service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type SchoolServiceClient interface {
	CreateSchool(ctx context.Context, in *SchoolRequest, opts ...grpc.CallOption) (*CreateResponse, error)
	CreateClass(ctx context.Context, in *ClassRequest, opts ...grpc.CallOption) (*CreateResponse, error)
	GetClass(ctx context.Context, in *ID, opts ...grpc.CallOption) (*ClassResponse, error)
	CreateStudent(ctx context.Context, in *StudentRequest, opts ...grpc.CallOption) (*CreateResponse, error)
	CheckHealth(ctx context.Context, in *HealthRequest, opts ...grpc.CallOption) (*HealthResponse, error)
}

type schoolServiceClient struct {
	cc grpc.ClientConnInterface
}

func NewSchoolServiceClient(cc grpc.ClientConnInterface) SchoolServiceClient {
	return &schoolServiceClient{cc}
}

func (c *schoolServiceClient) CreateSchool(ctx context.Context, in *SchoolRequest, opts ...grpc.CallOption) (*CreateResponse, error) {
	out := new(CreateResponse)
	err := c.cc.Invoke(ctx, "/school.SchoolService/CreateSchool", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *schoolServiceClient) CreateClass(ctx context.Context, in *ClassRequest, opts ...grpc.CallOption) (*CreateResponse, error) {
	out := new(CreateResponse)
	err := c.cc.Invoke(ctx, "/school.SchoolService/CreateClass", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *schoolServiceClient) GetClass(ctx context.Context, in *ID, opts ...grpc.CallOption) (*ClassResponse, error) {
	out := new(ClassResponse)
	err := c.cc.Invoke(ctx, "/school.SchoolService/GetClass", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *schoolServiceClient) CreateStudent(ctx context.Context, in *StudentRequest, opts ...grpc.CallOption) (*CreateResponse, error) {
	out := new(CreateResponse)
	err := c.cc.Invoke(ctx, "/school.SchoolService/CreateStudent", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *schoolServiceClient) CheckHealth(ctx context.Context, in *HealthRequest, opts ...grpc.CallOption) (*HealthResponse, error) {
	out := new(HealthResponse)
	err := c.cc.Invoke(ctx, "/school.SchoolService/CheckHealth", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// SchoolServiceServer is the server API for SchoolService service.
// All implementations should embed UnimplementedSchoolServiceServer
// for forward compatibility
type SchoolServiceServer interface {
	CreateSchool(context.Context, *SchoolRequest) (*CreateResponse, error)
	CreateClass(context.Context, *ClassRequest) (*CreateResponse, error)
	GetClass(context.Context, *ID) (*ClassResponse, error)
	CreateStudent(context.Context, *StudentRequest) (*CreateResponse, error)
	CheckHealth(context.Context, *HealthRequest) (*HealthResponse, error)
}

// UnimplementedSchoolServiceServer should be embedded to have forward compatible implementations.
type UnimplementedSchoolServiceServer struct {
}

func (UnimplementedSchoolServiceServer) CreateSchool(context.Context, *SchoolRequest) (*CreateResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method CreateSchool not implemented")
}
func (UnimplementedSchoolServiceServer) CreateClass(context.Context, *ClassRequest) (*CreateResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method CreateClass not implemented")
}
func (UnimplementedSchoolServiceServer) GetClass(context.Context, *ID) (*ClassResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetClass not implemented")
}
func (UnimplementedSchoolServiceServer) CreateStudent(context.Context, *StudentRequest) (*CreateResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method CreateStudent not implemented")
}
func (UnimplementedSchoolServiceServer) CheckHealth(context.Context, *HealthRequest) (*HealthResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method CheckHealth not implemented")
}

// UnsafeSchoolServiceServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to SchoolServiceServer will
// result in compilation errors.
type UnsafeSchoolServiceServer interface {
	mustEmbedUnimplementedSchoolServiceServer()
}

func RegisterSchoolServiceServer(s grpc.ServiceRegistrar, srv SchoolServiceServer) {
	s.RegisterService(&SchoolService_ServiceDesc, srv)
}

func _SchoolService_CreateSchool_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(SchoolRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(SchoolServiceServer).CreateSchool(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/school.SchoolService/CreateSchool",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(SchoolServiceServer).CreateSchool(ctx, req.(*SchoolRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _SchoolService_CreateClass_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(ClassRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(SchoolServiceServer).CreateClass(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/school.SchoolService/CreateClass",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(SchoolServiceServer).CreateClass(ctx, req.(*ClassRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _SchoolService_GetClass_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(ID)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(SchoolServiceServer).GetClass(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/school.SchoolService/GetClass",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(SchoolServiceServer).GetClass(ctx, req.(*ID))
	}
	return interceptor(ctx, in, info, handler)
}

func _SchoolService_CreateStudent_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(StudentRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(SchoolServiceServer).CreateStudent(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/school.SchoolService/CreateStudent",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(SchoolServiceServer).CreateStudent(ctx, req.(*StudentRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _SchoolService_CheckHealth_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(HealthRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(SchoolServiceServer).CheckHealth(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/school.SchoolService/CheckHealth",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(SchoolServiceServer).CheckHealth(ctx, req.(*HealthRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// SchoolService_ServiceDesc is the grpc.ServiceDesc for SchoolService service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var SchoolService_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "school.SchoolService",
	HandlerType: (*SchoolServiceServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "CreateSchool",
			Handler:    _SchoolService_CreateSchool_Handler,
		},
		{
			MethodName: "CreateClass",
			Handler:    _SchoolService_CreateClass_Handler,
		},
		{
			MethodName: "GetClass",
			Handler:    _SchoolService_GetClass_Handler,
		},
		{
			MethodName: "CreateStudent",
			Handler:    _SchoolService_CreateStudent_Handler,
		},
		{
			MethodName: "CheckHealth",
			Handler:    _SchoolService_CheckHealth_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "pkg/pb/school.proto",
}
