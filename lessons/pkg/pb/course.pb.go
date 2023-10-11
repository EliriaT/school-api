// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.28.1
// 	protoc        v3.12.4
// source: pkg/pb/course.proto

package pb

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type CourseRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Name      string `protobuf:"bytes,1,opt,name=name,proto3" json:"name,omitempty"`
	TeacherId int64  `protobuf:"varint,2,opt,name=teacherId,proto3" json:"teacherId,omitempty"`
	ClassId   int64  `protobuf:"varint,3,opt,name=classId,proto3" json:"classId,omitempty"`
}

func (x *CourseRequest) Reset() {
	*x = CourseRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pkg_pb_course_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *CourseRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*CourseRequest) ProtoMessage() {}

func (x *CourseRequest) ProtoReflect() protoreflect.Message {
	mi := &file_pkg_pb_course_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use CourseRequest.ProtoReflect.Descriptor instead.
func (*CourseRequest) Descriptor() ([]byte, []int) {
	return file_pkg_pb_course_proto_rawDescGZIP(), []int{0}
}

func (x *CourseRequest) GetName() string {
	if x != nil {
		return x.Name
	}
	return ""
}

func (x *CourseRequest) GetTeacherId() int64 {
	if x != nil {
		return x.TeacherId
	}
	return 0
}

func (x *CourseRequest) GetClassId() int64 {
	if x != nil {
		return x.ClassId
	}
	return 0
}

type LessonRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Name      string `protobuf:"bytes,1,opt,name=name,proto3" json:"name,omitempty"`
	CourseId  int64  `protobuf:"varint,2,opt,name=courseId,proto3" json:"courseId,omitempty"`
	StartHour string `protobuf:"bytes,3,opt,name=startHour,proto3" json:"startHour,omitempty"`
	EndHour   string `protobuf:"bytes,4,opt,name=endHour,proto3" json:"endHour,omitempty"`
	WeekDay   string `protobuf:"bytes,5,opt,name=weekDay,proto3" json:"weekDay,omitempty"`
	ClassRoom string `protobuf:"bytes,6,opt,name=classRoom,proto3" json:"classRoom,omitempty"`
}

func (x *LessonRequest) Reset() {
	*x = LessonRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pkg_pb_course_proto_msgTypes[1]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *LessonRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*LessonRequest) ProtoMessage() {}

func (x *LessonRequest) ProtoReflect() protoreflect.Message {
	mi := &file_pkg_pb_course_proto_msgTypes[1]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use LessonRequest.ProtoReflect.Descriptor instead.
func (*LessonRequest) Descriptor() ([]byte, []int) {
	return file_pkg_pb_course_proto_rawDescGZIP(), []int{1}
}

func (x *LessonRequest) GetName() string {
	if x != nil {
		return x.Name
	}
	return ""
}

func (x *LessonRequest) GetCourseId() int64 {
	if x != nil {
		return x.CourseId
	}
	return 0
}

func (x *LessonRequest) GetStartHour() string {
	if x != nil {
		return x.StartHour
	}
	return ""
}

func (x *LessonRequest) GetEndHour() string {
	if x != nil {
		return x.EndHour
	}
	return ""
}

func (x *LessonRequest) GetWeekDay() string {
	if x != nil {
		return x.WeekDay
	}
	return ""
}

func (x *LessonRequest) GetClassRoom() string {
	if x != nil {
		return x.ClassRoom
	}
	return ""
}

type MarkRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	CourseId  int64  `protobuf:"varint,1,opt,name=courseId,proto3" json:"courseId,omitempty"`
	MarkDate  string `protobuf:"bytes,2,opt,name=markDate,proto3" json:"markDate,omitempty"`
	IsAbsent  bool   `protobuf:"varint,3,opt,name=isAbsent,proto3" json:"isAbsent,omitempty"`
	Mark      int32  `protobuf:"varint,4,opt,name=mark,proto3" json:"mark,omitempty"`
	StudentId int64  `protobuf:"varint,5,opt,name=studentId,proto3" json:"studentId,omitempty"`
}

func (x *MarkRequest) Reset() {
	*x = MarkRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pkg_pb_course_proto_msgTypes[2]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *MarkRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*MarkRequest) ProtoMessage() {}

func (x *MarkRequest) ProtoReflect() protoreflect.Message {
	mi := &file_pkg_pb_course_proto_msgTypes[2]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use MarkRequest.ProtoReflect.Descriptor instead.
func (*MarkRequest) Descriptor() ([]byte, []int) {
	return file_pkg_pb_course_proto_rawDescGZIP(), []int{2}
}

func (x *MarkRequest) GetCourseId() int64 {
	if x != nil {
		return x.CourseId
	}
	return 0
}

func (x *MarkRequest) GetMarkDate() string {
	if x != nil {
		return x.MarkDate
	}
	return ""
}

func (x *MarkRequest) GetIsAbsent() bool {
	if x != nil {
		return x.IsAbsent
	}
	return false
}

func (x *MarkRequest) GetMark() int32 {
	if x != nil {
		return x.Mark
	}
	return 0
}

func (x *MarkRequest) GetStudentId() int64 {
	if x != nil {
		return x.StudentId
	}
	return 0
}

type CourseCreateResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Status int64  `protobuf:"varint,1,opt,name=status,proto3" json:"status,omitempty"`
	Error  string `protobuf:"bytes,2,opt,name=error,proto3" json:"error,omitempty"`
}

func (x *CourseCreateResponse) Reset() {
	*x = CourseCreateResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pkg_pb_course_proto_msgTypes[3]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *CourseCreateResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*CourseCreateResponse) ProtoMessage() {}

func (x *CourseCreateResponse) ProtoReflect() protoreflect.Message {
	mi := &file_pkg_pb_course_proto_msgTypes[3]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use CourseCreateResponse.ProtoReflect.Descriptor instead.
func (*CourseCreateResponse) Descriptor() ([]byte, []int) {
	return file_pkg_pb_course_proto_rawDescGZIP(), []int{3}
}

func (x *CourseCreateResponse) GetStatus() int64 {
	if x != nil {
		return x.Status
	}
	return 0
}

func (x *CourseCreateResponse) GetError() string {
	if x != nil {
		return x.Error
	}
	return ""
}

type Course struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Id        int64   `protobuf:"varint,1,opt,name=id,proto3" json:"id,omitempty"`
	Name      string  `protobuf:"bytes,2,opt,name=name,proto3" json:"name,omitempty"`
	TeacherId int64   `protobuf:"varint,3,opt,name=teacherId,proto3" json:"teacherId,omitempty"`
	ClassId   int64   `protobuf:"varint,4,opt,name=classId,proto3" json:"classId,omitempty"`
	Marks     []*Mark `protobuf:"bytes,5,rep,name=marks,proto3" json:"marks,omitempty"`
}

func (x *Course) Reset() {
	*x = Course{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pkg_pb_course_proto_msgTypes[4]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *Course) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*Course) ProtoMessage() {}

func (x *Course) ProtoReflect() protoreflect.Message {
	mi := &file_pkg_pb_course_proto_msgTypes[4]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use Course.ProtoReflect.Descriptor instead.
func (*Course) Descriptor() ([]byte, []int) {
	return file_pkg_pb_course_proto_rawDescGZIP(), []int{4}
}

func (x *Course) GetId() int64 {
	if x != nil {
		return x.Id
	}
	return 0
}

func (x *Course) GetName() string {
	if x != nil {
		return x.Name
	}
	return ""
}

func (x *Course) GetTeacherId() int64 {
	if x != nil {
		return x.TeacherId
	}
	return 0
}

func (x *Course) GetClassId() int64 {
	if x != nil {
		return x.ClassId
	}
	return 0
}

func (x *Course) GetMarks() []*Mark {
	if x != nil {
		return x.Marks
	}
	return nil
}

type Mark struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Id        int64  `protobuf:"varint,1,opt,name=id,proto3" json:"id,omitempty"`
	CourseId  int64  `protobuf:"varint,2,opt,name=courseId,proto3" json:"courseId,omitempty"`
	MarkDate  string `protobuf:"bytes,3,opt,name=markDate,proto3" json:"markDate,omitempty"`
	IsAbsent  bool   `protobuf:"varint,4,opt,name=isAbsent,proto3" json:"isAbsent,omitempty"`
	Mark      int32  `protobuf:"varint,5,opt,name=mark,proto3" json:"mark,omitempty"`
	StudentId int64  `protobuf:"varint,6,opt,name=studentId,proto3" json:"studentId,omitempty"`
}

func (x *Mark) Reset() {
	*x = Mark{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pkg_pb_course_proto_msgTypes[5]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *Mark) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*Mark) ProtoMessage() {}

func (x *Mark) ProtoReflect() protoreflect.Message {
	mi := &file_pkg_pb_course_proto_msgTypes[5]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use Mark.ProtoReflect.Descriptor instead.
func (*Mark) Descriptor() ([]byte, []int) {
	return file_pkg_pb_course_proto_rawDescGZIP(), []int{5}
}

func (x *Mark) GetId() int64 {
	if x != nil {
		return x.Id
	}
	return 0
}

func (x *Mark) GetCourseId() int64 {
	if x != nil {
		return x.CourseId
	}
	return 0
}

func (x *Mark) GetMarkDate() string {
	if x != nil {
		return x.MarkDate
	}
	return ""
}

func (x *Mark) GetIsAbsent() bool {
	if x != nil {
		return x.IsAbsent
	}
	return false
}

func (x *Mark) GetMark() int32 {
	if x != nil {
		return x.Mark
	}
	return 0
}

func (x *Mark) GetStudentId() int64 {
	if x != nil {
		return x.StudentId
	}
	return 0
}

type CourseResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Status int64   `protobuf:"varint,1,opt,name=status,proto3" json:"status,omitempty"`
	Error  string  `protobuf:"bytes,2,opt,name=error,proto3" json:"error,omitempty"`
	Data   *Course `protobuf:"bytes,3,opt,name=data,proto3" json:"data,omitempty"`
}

func (x *CourseResponse) Reset() {
	*x = CourseResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pkg_pb_course_proto_msgTypes[6]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *CourseResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*CourseResponse) ProtoMessage() {}

func (x *CourseResponse) ProtoReflect() protoreflect.Message {
	mi := &file_pkg_pb_course_proto_msgTypes[6]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use CourseResponse.ProtoReflect.Descriptor instead.
func (*CourseResponse) Descriptor() ([]byte, []int) {
	return file_pkg_pb_course_proto_rawDescGZIP(), []int{6}
}

func (x *CourseResponse) GetStatus() int64 {
	if x != nil {
		return x.Status
	}
	return 0
}

func (x *CourseResponse) GetError() string {
	if x != nil {
		return x.Error
	}
	return ""
}

func (x *CourseResponse) GetData() *Course {
	if x != nil {
		return x.Data
	}
	return nil
}

type CourseID struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Id int64 `protobuf:"varint,1,opt,name=id,proto3" json:"id,omitempty"`
}

func (x *CourseID) Reset() {
	*x = CourseID{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pkg_pb_course_proto_msgTypes[7]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *CourseID) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*CourseID) ProtoMessage() {}

func (x *CourseID) ProtoReflect() protoreflect.Message {
	mi := &file_pkg_pb_course_proto_msgTypes[7]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use CourseID.ProtoReflect.Descriptor instead.
func (*CourseID) Descriptor() ([]byte, []int) {
	return file_pkg_pb_course_proto_rawDescGZIP(), []int{7}
}

func (x *CourseID) GetId() int64 {
	if x != nil {
		return x.Id
	}
	return 0
}

var File_pkg_pb_course_proto protoreflect.FileDescriptor

var file_pkg_pb_course_proto_rawDesc = []byte{
	0x0a, 0x13, 0x70, 0x6b, 0x67, 0x2f, 0x70, 0x62, 0x2f, 0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x06, 0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x22, 0x5b, 0x0a,
	0x0d, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x12,
	0x0a, 0x04, 0x6e, 0x61, 0x6d, 0x65, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x04, 0x6e, 0x61,
	0x6d, 0x65, 0x12, 0x1c, 0x0a, 0x09, 0x74, 0x65, 0x61, 0x63, 0x68, 0x65, 0x72, 0x49, 0x64, 0x18,
	0x02, 0x20, 0x01, 0x28, 0x03, 0x52, 0x09, 0x74, 0x65, 0x61, 0x63, 0x68, 0x65, 0x72, 0x49, 0x64,
	0x12, 0x18, 0x0a, 0x07, 0x63, 0x6c, 0x61, 0x73, 0x73, 0x49, 0x64, 0x18, 0x03, 0x20, 0x01, 0x28,
	0x03, 0x52, 0x07, 0x63, 0x6c, 0x61, 0x73, 0x73, 0x49, 0x64, 0x22, 0xaf, 0x01, 0x0a, 0x0d, 0x4c,
	0x65, 0x73, 0x73, 0x6f, 0x6e, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x12, 0x0a, 0x04,
	0x6e, 0x61, 0x6d, 0x65, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x04, 0x6e, 0x61, 0x6d, 0x65,
	0x12, 0x1a, 0x0a, 0x08, 0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x49, 0x64, 0x18, 0x02, 0x20, 0x01,
	0x28, 0x03, 0x52, 0x08, 0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x49, 0x64, 0x12, 0x1c, 0x0a, 0x09,
	0x73, 0x74, 0x61, 0x72, 0x74, 0x48, 0x6f, 0x75, 0x72, 0x18, 0x03, 0x20, 0x01, 0x28, 0x09, 0x52,
	0x09, 0x73, 0x74, 0x61, 0x72, 0x74, 0x48, 0x6f, 0x75, 0x72, 0x12, 0x18, 0x0a, 0x07, 0x65, 0x6e,
	0x64, 0x48, 0x6f, 0x75, 0x72, 0x18, 0x04, 0x20, 0x01, 0x28, 0x09, 0x52, 0x07, 0x65, 0x6e, 0x64,
	0x48, 0x6f, 0x75, 0x72, 0x12, 0x18, 0x0a, 0x07, 0x77, 0x65, 0x65, 0x6b, 0x44, 0x61, 0x79, 0x18,
	0x05, 0x20, 0x01, 0x28, 0x09, 0x52, 0x07, 0x77, 0x65, 0x65, 0x6b, 0x44, 0x61, 0x79, 0x12, 0x1c,
	0x0a, 0x09, 0x63, 0x6c, 0x61, 0x73, 0x73, 0x52, 0x6f, 0x6f, 0x6d, 0x18, 0x06, 0x20, 0x01, 0x28,
	0x09, 0x52, 0x09, 0x63, 0x6c, 0x61, 0x73, 0x73, 0x52, 0x6f, 0x6f, 0x6d, 0x22, 0x93, 0x01, 0x0a,
	0x0b, 0x4d, 0x61, 0x72, 0x6b, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x1a, 0x0a, 0x08,
	0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x49, 0x64, 0x18, 0x01, 0x20, 0x01, 0x28, 0x03, 0x52, 0x08,
	0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x49, 0x64, 0x12, 0x1a, 0x0a, 0x08, 0x6d, 0x61, 0x72, 0x6b,
	0x44, 0x61, 0x74, 0x65, 0x18, 0x02, 0x20, 0x01, 0x28, 0x09, 0x52, 0x08, 0x6d, 0x61, 0x72, 0x6b,
	0x44, 0x61, 0x74, 0x65, 0x12, 0x1a, 0x0a, 0x08, 0x69, 0x73, 0x41, 0x62, 0x73, 0x65, 0x6e, 0x74,
	0x18, 0x03, 0x20, 0x01, 0x28, 0x08, 0x52, 0x08, 0x69, 0x73, 0x41, 0x62, 0x73, 0x65, 0x6e, 0x74,
	0x12, 0x12, 0x0a, 0x04, 0x6d, 0x61, 0x72, 0x6b, 0x18, 0x04, 0x20, 0x01, 0x28, 0x05, 0x52, 0x04,
	0x6d, 0x61, 0x72, 0x6b, 0x12, 0x1c, 0x0a, 0x09, 0x73, 0x74, 0x75, 0x64, 0x65, 0x6e, 0x74, 0x49,
	0x64, 0x18, 0x05, 0x20, 0x01, 0x28, 0x03, 0x52, 0x09, 0x73, 0x74, 0x75, 0x64, 0x65, 0x6e, 0x74,
	0x49, 0x64, 0x22, 0x44, 0x0a, 0x14, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x43, 0x72, 0x65, 0x61,
	0x74, 0x65, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x12, 0x16, 0x0a, 0x06, 0x73, 0x74,
	0x61, 0x74, 0x75, 0x73, 0x18, 0x01, 0x20, 0x01, 0x28, 0x03, 0x52, 0x06, 0x73, 0x74, 0x61, 0x74,
	0x75, 0x73, 0x12, 0x14, 0x0a, 0x05, 0x65, 0x72, 0x72, 0x6f, 0x72, 0x18, 0x02, 0x20, 0x01, 0x28,
	0x09, 0x52, 0x05, 0x65, 0x72, 0x72, 0x6f, 0x72, 0x22, 0x88, 0x01, 0x0a, 0x06, 0x43, 0x6f, 0x75,
	0x72, 0x73, 0x65, 0x12, 0x0e, 0x0a, 0x02, 0x69, 0x64, 0x18, 0x01, 0x20, 0x01, 0x28, 0x03, 0x52,
	0x02, 0x69, 0x64, 0x12, 0x12, 0x0a, 0x04, 0x6e, 0x61, 0x6d, 0x65, 0x18, 0x02, 0x20, 0x01, 0x28,
	0x09, 0x52, 0x04, 0x6e, 0x61, 0x6d, 0x65, 0x12, 0x1c, 0x0a, 0x09, 0x74, 0x65, 0x61, 0x63, 0x68,
	0x65, 0x72, 0x49, 0x64, 0x18, 0x03, 0x20, 0x01, 0x28, 0x03, 0x52, 0x09, 0x74, 0x65, 0x61, 0x63,
	0x68, 0x65, 0x72, 0x49, 0x64, 0x12, 0x18, 0x0a, 0x07, 0x63, 0x6c, 0x61, 0x73, 0x73, 0x49, 0x64,
	0x18, 0x04, 0x20, 0x01, 0x28, 0x03, 0x52, 0x07, 0x63, 0x6c, 0x61, 0x73, 0x73, 0x49, 0x64, 0x12,
	0x22, 0x0a, 0x05, 0x6d, 0x61, 0x72, 0x6b, 0x73, 0x18, 0x05, 0x20, 0x03, 0x28, 0x0b, 0x32, 0x0c,
	0x2e, 0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x2e, 0x4d, 0x61, 0x72, 0x6b, 0x52, 0x05, 0x6d, 0x61,
	0x72, 0x6b, 0x73, 0x22, 0x9c, 0x01, 0x0a, 0x04, 0x4d, 0x61, 0x72, 0x6b, 0x12, 0x0e, 0x0a, 0x02,
	0x69, 0x64, 0x18, 0x01, 0x20, 0x01, 0x28, 0x03, 0x52, 0x02, 0x69, 0x64, 0x12, 0x1a, 0x0a, 0x08,
	0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x49, 0x64, 0x18, 0x02, 0x20, 0x01, 0x28, 0x03, 0x52, 0x08,
	0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x49, 0x64, 0x12, 0x1a, 0x0a, 0x08, 0x6d, 0x61, 0x72, 0x6b,
	0x44, 0x61, 0x74, 0x65, 0x18, 0x03, 0x20, 0x01, 0x28, 0x09, 0x52, 0x08, 0x6d, 0x61, 0x72, 0x6b,
	0x44, 0x61, 0x74, 0x65, 0x12, 0x1a, 0x0a, 0x08, 0x69, 0x73, 0x41, 0x62, 0x73, 0x65, 0x6e, 0x74,
	0x18, 0x04, 0x20, 0x01, 0x28, 0x08, 0x52, 0x08, 0x69, 0x73, 0x41, 0x62, 0x73, 0x65, 0x6e, 0x74,
	0x12, 0x12, 0x0a, 0x04, 0x6d, 0x61, 0x72, 0x6b, 0x18, 0x05, 0x20, 0x01, 0x28, 0x05, 0x52, 0x04,
	0x6d, 0x61, 0x72, 0x6b, 0x12, 0x1c, 0x0a, 0x09, 0x73, 0x74, 0x75, 0x64, 0x65, 0x6e, 0x74, 0x49,
	0x64, 0x18, 0x06, 0x20, 0x01, 0x28, 0x03, 0x52, 0x09, 0x73, 0x74, 0x75, 0x64, 0x65, 0x6e, 0x74,
	0x49, 0x64, 0x22, 0x62, 0x0a, 0x0e, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x52, 0x65, 0x73, 0x70,
	0x6f, 0x6e, 0x73, 0x65, 0x12, 0x16, 0x0a, 0x06, 0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x18, 0x01,
	0x20, 0x01, 0x28, 0x03, 0x52, 0x06, 0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x12, 0x14, 0x0a, 0x05,
	0x65, 0x72, 0x72, 0x6f, 0x72, 0x18, 0x02, 0x20, 0x01, 0x28, 0x09, 0x52, 0x05, 0x65, 0x72, 0x72,
	0x6f, 0x72, 0x12, 0x22, 0x0a, 0x04, 0x64, 0x61, 0x74, 0x61, 0x18, 0x03, 0x20, 0x01, 0x28, 0x0b,
	0x32, 0x0e, 0x2e, 0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x2e, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65,
	0x52, 0x04, 0x64, 0x61, 0x74, 0x61, 0x22, 0x1a, 0x0a, 0x08, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65,
	0x49, 0x44, 0x12, 0x0e, 0x0a, 0x02, 0x69, 0x64, 0x18, 0x01, 0x20, 0x01, 0x28, 0x03, 0x52, 0x02,
	0x69, 0x64, 0x32, 0x99, 0x02, 0x0a, 0x0d, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x53, 0x65, 0x72,
	0x76, 0x69, 0x63, 0x65, 0x12, 0x45, 0x0a, 0x0c, 0x43, 0x72, 0x65, 0x61, 0x74, 0x65, 0x43, 0x6f,
	0x75, 0x72, 0x73, 0x65, 0x12, 0x15, 0x2e, 0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x2e, 0x43, 0x6f,
	0x75, 0x72, 0x73, 0x65, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x1c, 0x2e, 0x63, 0x6f,
	0x75, 0x72, 0x73, 0x65, 0x2e, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x43, 0x72, 0x65, 0x61, 0x74,
	0x65, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x12, 0x37, 0x0a, 0x09, 0x47,
	0x65, 0x74, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x12, 0x10, 0x2e, 0x63, 0x6f, 0x75, 0x72, 0x73,
	0x65, 0x2e, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x49, 0x44, 0x1a, 0x16, 0x2e, 0x63, 0x6f, 0x75,
	0x72, 0x73, 0x65, 0x2e, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e,
	0x73, 0x65, 0x22, 0x00, 0x12, 0x45, 0x0a, 0x0c, 0x43, 0x72, 0x65, 0x61, 0x74, 0x65, 0x4c, 0x65,
	0x73, 0x73, 0x6f, 0x6e, 0x12, 0x15, 0x2e, 0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x2e, 0x4c, 0x65,
	0x73, 0x73, 0x6f, 0x6e, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x1c, 0x2e, 0x63, 0x6f,
	0x75, 0x72, 0x73, 0x65, 0x2e, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x43, 0x72, 0x65, 0x61, 0x74,
	0x65, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x12, 0x41, 0x0a, 0x0a, 0x43,
	0x72, 0x65, 0x61, 0x74, 0x65, 0x4d, 0x61, 0x72, 0x6b, 0x12, 0x13, 0x2e, 0x63, 0x6f, 0x75, 0x72,
	0x73, 0x65, 0x2e, 0x4d, 0x61, 0x72, 0x6b, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x1c,
	0x2e, 0x63, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x2e, 0x43, 0x6f, 0x75, 0x72, 0x73, 0x65, 0x43, 0x72,
	0x65, 0x61, 0x74, 0x65, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x42, 0x0a,
	0x5a, 0x08, 0x2e, 0x2f, 0x70, 0x6b, 0x67, 0x2f, 0x70, 0x62, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74,
	0x6f, 0x33,
}

var (
	file_pkg_pb_course_proto_rawDescOnce sync.Once
	file_pkg_pb_course_proto_rawDescData = file_pkg_pb_course_proto_rawDesc
)

func file_pkg_pb_course_proto_rawDescGZIP() []byte {
	file_pkg_pb_course_proto_rawDescOnce.Do(func() {
		file_pkg_pb_course_proto_rawDescData = protoimpl.X.CompressGZIP(file_pkg_pb_course_proto_rawDescData)
	})
	return file_pkg_pb_course_proto_rawDescData
}

var file_pkg_pb_course_proto_msgTypes = make([]protoimpl.MessageInfo, 8)
var file_pkg_pb_course_proto_goTypes = []interface{}{
	(*CourseRequest)(nil),        // 0: course.CourseRequest
	(*LessonRequest)(nil),        // 1: course.LessonRequest
	(*MarkRequest)(nil),          // 2: course.MarkRequest
	(*CourseCreateResponse)(nil), // 3: course.CourseCreateResponse
	(*Course)(nil),               // 4: course.Course
	(*Mark)(nil),                 // 5: course.Mark
	(*CourseResponse)(nil),       // 6: course.CourseResponse
	(*CourseID)(nil),             // 7: course.CourseID
}
var file_pkg_pb_course_proto_depIdxs = []int32{
	5, // 0: course.Course.marks:type_name -> course.Mark
	4, // 1: course.CourseResponse.data:type_name -> course.Course
	0, // 2: course.CourseService.CreateCourse:input_type -> course.CourseRequest
	7, // 3: course.CourseService.GetCourse:input_type -> course.CourseID
	1, // 4: course.CourseService.CreateLesson:input_type -> course.LessonRequest
	2, // 5: course.CourseService.CreateMark:input_type -> course.MarkRequest
	3, // 6: course.CourseService.CreateCourse:output_type -> course.CourseCreateResponse
	6, // 7: course.CourseService.GetCourse:output_type -> course.CourseResponse
	3, // 8: course.CourseService.CreateLesson:output_type -> course.CourseCreateResponse
	3, // 9: course.CourseService.CreateMark:output_type -> course.CourseCreateResponse
	6, // [6:10] is the sub-list for method output_type
	2, // [2:6] is the sub-list for method input_type
	2, // [2:2] is the sub-list for extension type_name
	2, // [2:2] is the sub-list for extension extendee
	0, // [0:2] is the sub-list for field type_name
}

func init() { file_pkg_pb_course_proto_init() }
func file_pkg_pb_course_proto_init() {
	if File_pkg_pb_course_proto != nil {
		return
	}
	if !protoimpl.UnsafeEnabled {
		file_pkg_pb_course_proto_msgTypes[0].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*CourseRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_pkg_pb_course_proto_msgTypes[1].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*LessonRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_pkg_pb_course_proto_msgTypes[2].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*MarkRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_pkg_pb_course_proto_msgTypes[3].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*CourseCreateResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_pkg_pb_course_proto_msgTypes[4].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*Course); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_pkg_pb_course_proto_msgTypes[5].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*Mark); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_pkg_pb_course_proto_msgTypes[6].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*CourseResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_pkg_pb_course_proto_msgTypes[7].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*CourseID); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_pkg_pb_course_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   8,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_pkg_pb_course_proto_goTypes,
		DependencyIndexes: file_pkg_pb_course_proto_depIdxs,
		MessageInfos:      file_pkg_pb_course_proto_msgTypes,
	}.Build()
	File_pkg_pb_course_proto = out.File
	file_pkg_pb_course_proto_rawDesc = nil
	file_pkg_pb_course_proto_goTypes = nil
	file_pkg_pb_course_proto_depIdxs = nil
}
