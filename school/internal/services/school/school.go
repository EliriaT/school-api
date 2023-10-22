package school

import (
	"context"
	"github.com/EliriaT/school-api/school/internal/db"
	"github.com/EliriaT/school-api/school/pkg/models"
	"github.com/EliriaT/school-api/school/pkg/pb"
	"log"
	"net/http"
)

type SchoolServer struct {
	Handler db.Handler
}

// TODO can provide the info about connections
func (c *SchoolServer) CheckHealth(ctx context.Context, req *pb.HealthRequest) (*pb.HealthResponse, error) {

	sqlDB, err := c.Handler.DB.DB()
	if err != nil {
		return &pb.HealthResponse{Healthy: false}, nil
	}
	err = sqlDB.Ping()
	if err != nil {
		return &pb.HealthResponse{Healthy: false}, nil
	}
	log.Println("Ping received")
	return &pb.HealthResponse{Healthy: true}, nil
}

func (s *SchoolServer) CreateSchool(ctx context.Context, req *pb.SchoolRequest) (*pb.CreateResponse, error) {
	var school models.School

	school.Name = req.Name

	result := s.Handler.DB.Create(&school)
	if result.Error != nil {
		return &pb.CreateResponse{
			Status: http.StatusInternalServerError,
			Error:  result.Error.Error()}, nil
	}
	return &pb.CreateResponse{Status: http.StatusCreated}, nil
}

// TODO SHOULD ADD UNIQUE CONSTRAIN ON USER ID AND CLASS ID AND CHECK USER ROLE
func (s *SchoolServer) CreateStudent(ctx context.Context, req *pb.StudentRequest) (*pb.CreateResponse, error) {
	var student models.Student

	var class models.Class
	if result := s.Handler.DB.First(&class, req.ClassID); result.Error != nil {
		return &pb.CreateResponse{
			Status: http.StatusNotFound,
			Error:  result.Error.Error(),
		}, nil
	}

	var user models.User
	if result := s.Handler.DB.First(&user, req.UserID); result.Error != nil {
		return &pb.CreateResponse{
			Status: http.StatusNotFound,
			Error:  result.Error.Error(),
		}, nil
	}

	student.UserID = req.UserID
	student.ClassID = req.ClassID

	result := s.Handler.DB.Create(&student)
	if result.Error != nil {
		return &pb.CreateResponse{
			Status: http.StatusInternalServerError,
			Error:  result.Error.Error()}, nil
	}
	return &pb.CreateResponse{Status: http.StatusCreated}, nil
}

func (s *SchoolServer) CreateClass(ctx context.Context, req *pb.ClassRequest) (*pb.CreateResponse, error) {
	var class models.Class

	class.Name = req.Name
	class.HeadTeacherId = req.HeadTeacher
	class.SchoolId = req.SchoolId

	var user models.User
	if result := s.Handler.DB.First(&user, req.HeadTeacher); result.Error != nil {
		return &pb.CreateResponse{
			Status: http.StatusNotFound,
			Error:  result.Error.Error(),
		}, nil
	}

	var school models.School
	if result := s.Handler.DB.First(&school, req.SchoolId); result.Error != nil {
		return &pb.CreateResponse{
			Status: http.StatusNotFound,
			Error:  result.Error.Error(),
		}, nil
	}

	result := s.Handler.DB.Create(&class)
	if result.Error != nil {
		return &pb.CreateResponse{
			Status: http.StatusInternalServerError,
			Error:  result.Error.Error()}, nil
	}
	return &pb.CreateResponse{Status: http.StatusCreated}, nil
}

func (s *SchoolServer) GetClass(ctx context.Context, req *pb.ID) (*pb.ClassResponse, error) {
	var class models.Class

	// this is for testing concurrency task limit
	//s.Handler.DB.Transaction(func(tx *gorm.DB) error {
	//	time.Sleep(time.Second * 8)
	//
	//	// return nil will commit the whole transaction
	//	return nil
	//})

	if result := s.Handler.DB.First(&class, req.Id); result.Error != nil {
		return &pb.ClassResponse{
			Status: http.StatusNotFound,
			Error:  result.Error.Error(),
		}, nil
	}

	data := &pb.Class{
		Id:          class.ID,
		Name:        class.Name,
		HeadTeacher: class.HeadTeacherId,
		SchoolId:    class.SchoolId,
	}
	// this is for testing request timeout
	// time.Sleep(time.Minute * 1)
	return &pb.ClassResponse{
		Status: http.StatusOK,
		Data:   data,
	}, nil
}
