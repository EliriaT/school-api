package services

import (
	"context"
	"github.com/EliriaT/school-api/lessons/internal/db"
	"github.com/EliriaT/school-api/lessons/pkg/client"
	"github.com/EliriaT/school-api/lessons/pkg/models"
	"github.com/EliriaT/school-api/lessons/pkg/pb"
	"net/http"
)

type CourseServer struct {
	Handler      db.Handler
	SchoolClient client.SchoolServiceClient
	AuthClient   client.AuthServiceClient
}

func (c *CourseServer) CheckHealth(ctx context.Context, req *pb.HealthRequest) (*pb.HealthResponse, error) {

	sqlDB, err := c.Handler.DB.DB()
	if err != nil {
		return &pb.HealthResponse{Healthy: false}, nil
	}
	err = sqlDB.Ping()
	if err != nil {
		return &pb.HealthResponse{Healthy: false}, nil
	}
	return &pb.HealthResponse{Healthy: true}, nil
}

func (c *CourseServer) CreateCourse(ctx context.Context, request *pb.CourseRequest) (*pb.CourseCreateResponse, error) {
	var course models.Course

	// TODO should check role of user so that it is teacher
	class, err := c.SchoolClient.GetClass(request.ClassId)
	if err != nil {
		return &pb.CourseCreateResponse{
			Status: http.StatusNotFound,
			Error:  err.Error()}, nil
	}

	if class.Status != http.StatusOK {
		return &pb.CourseCreateResponse{
			Status: http.StatusNotFound,
			Error:  "Class not found"}, nil
	}

	user, err := c.AuthClient.GetUser(request.TeacherId)
	if err != nil {
		return &pb.CourseCreateResponse{
			Status: http.StatusNotFound,
			Error:  err.Error()}, nil
	}

	if user.Status != http.StatusOK {
		return &pb.CourseCreateResponse{
			Status: http.StatusNotFound,
			Error:  "User not found"}, nil
	}

	course.Name = request.Name
	course.ClassID = request.ClassId
	course.TeacherID = request.TeacherId

	result := c.Handler.DB.Create(&course)
	if result.Error != nil {
		return &pb.CourseCreateResponse{
			Status: http.StatusInternalServerError,
			Error:  result.Error.Error()}, nil
	}
	return &pb.CourseCreateResponse{Status: http.StatusCreated}, nil
}

func (c *CourseServer) GetCourse(ctx context.Context, req *pb.CourseID) (*pb.CourseResponse, error) {
	var course models.Course
	if result := c.Handler.DB.Preload("Marks").First(&course, req.Id); result.Error != nil {
		return &pb.CourseResponse{
			Status: http.StatusNotFound,
			Error:  result.Error.Error(),
		}, nil
	}

	data := &pb.Course{
		Id:        course.ID,
		Name:      course.Name,
		TeacherId: course.TeacherID,
		ClassId:   course.ClassID,
	}

	for _, mark := range course.Marks {
		data.Marks = append(data.Marks, &pb.Mark{
			Id:        mark.ID,
			CourseId:  mark.CourseID,
			MarkDate:  mark.MarkDate,
			IsAbsent:  mark.IsAbsent,
			Mark:      mark.Mark,
			StudentId: mark.StudentID,
		})
	}

	return &pb.CourseResponse{
		Status: http.StatusOK,
		Data:   data,
	}, nil
}

func (c *CourseServer) CreateLesson(ctx context.Context, request *pb.LessonRequest) (*pb.CourseCreateResponse, error) {
	var lesson models.Lesson

	var course models.Course
	if result := c.Handler.DB.First(&course, request.CourseId); result.Error != nil {
		return &pb.CourseCreateResponse{
			Status: http.StatusNotFound,
			Error:  result.Error.Error(),
		}, nil
	}

	lesson.Name = request.Name
	lesson.CourseID = request.CourseId
	lesson.Classroom = request.ClassRoom
	lesson.StartHour = request.StartHour
	lesson.EndHour = request.EndHour
	lesson.WeekDay = request.WeekDay

	result := c.Handler.DB.Create(&lesson)
	if result.Error != nil {
		return &pb.CourseCreateResponse{
			Status: http.StatusInternalServerError,
			Error:  result.Error.Error()}, nil
	}
	return &pb.CourseCreateResponse{Status: http.StatusCreated}, nil
}

func (c *CourseServer) CreateMark(ctx context.Context, request *pb.MarkRequest) (*pb.CourseCreateResponse, error) {
	var mark models.Mark

	// TODO check existence of student ID
	// TODO should check role of user
	user, err := c.AuthClient.GetUser(request.StudentId)
	if err != nil {
		return &pb.CourseCreateResponse{
			Status: http.StatusNotFound,
			Error:  err.Error()}, nil
	}
	if user.Status != http.StatusOK {
		return &pb.CourseCreateResponse{
			Status: http.StatusNotFound,
			Error:  "User not found"}, nil
	}

	var course models.Course
	if result := c.Handler.DB.First(&course, request.CourseId); result.Error != nil {
		return &pb.CourseCreateResponse{
			Status: http.StatusNotFound,
			Error:  result.Error.Error(),
		}, nil
	}

	mark.MarkDate = request.MarkDate
	mark.Mark = request.Mark
	mark.CourseID = request.CourseId
	mark.IsAbsent = request.IsAbsent
	mark.StudentID = request.StudentId

	result := c.Handler.DB.Create(&mark)
	if result.Error != nil {
		return &pb.CourseCreateResponse{
			Status: http.StatusInternalServerError,
			Error:  result.Error.Error()}, nil
	}
	return &pb.CourseCreateResponse{Status: http.StatusCreated}, nil
}
