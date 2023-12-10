package auth

import (
	"context"
	"github.com/EliriaT/school-api/school/internal/db"
	"github.com/EliriaT/school-api/school/pkg/config"
	"github.com/EliriaT/school-api/school/pkg/models"
	"github.com/EliriaT/school-api/school/pkg/pb"
	"net/http"
	"time"
)

type AuthServer struct {
	Handler db.Handler
	Jwt     JwtWrapper
	Config  config.Config // used to test circuit breakers
}

func (s *AuthServer) GetUser(ctx context.Context, req *pb.EntityID) (*pb.UserResponse, error) {
	var user models.User
	if result := s.Handler.DB.First(&user, req.Id); result.Error != nil {
		return &pb.UserResponse{
			Status: http.StatusNotFound,
			Error:  result.Error.Error(),
		}, nil
	}

	data := &pb.User{
		Id:       user.ID,
		Email:    user.Email,
		Name:     user.Name,
		SchoolId: user.SchoolId,
		RoleId:   user.RoleId,
	}

	return &pb.UserResponse{
		Status: http.StatusOK,
		Data:   data,
	}, nil
}

// TODO SHULD CHECK ROLE FOR ENUM
func (s *AuthServer) Register(ctx context.Context, req *pb.RegisterRequest) (*pb.RegisterResponse, error) {
	var user models.User

	// testing rerouting of request with service high availability. Comment "if" for checking tripping of Circuit Breaker
	if s.Config.MyUrl == "school-service:8081" {
		time.Sleep(time.Second * 10)
	}

	if result := s.Handler.DB.Where(&models.User{Email: req.Email}).First(&user); result.Error == nil {
		return &pb.RegisterResponse{
			Status: http.StatusBadRequest,
			Error:  "Email already exists",
		}, nil
	}

	var school models.School
	if result := s.Handler.DB.First(&school, req.SchoolId); result.Error != nil {
		return &pb.RegisterResponse{
			Status: http.StatusNotFound,
			Error:  "No such school",
		}, nil
	}

	user.Email = req.Email
	password, err := HashPassword(req.Password)
	if err != nil {
		return &pb.RegisterResponse{
			Status: http.StatusInternalServerError,
		}, nil
	}
	user.Password = password
	user.Name = req.Name
	user.SchoolId = req.SchoolId
	user.RoleId = req.RoleId

	if result := s.Handler.DB.Create(&user); result.Error != nil {
		return &pb.RegisterResponse{
			Status: http.StatusInternalServerError,
			Error:  result.Error.Error()}, nil
	}

	return &pb.RegisterResponse{
		Status: http.StatusCreated,
	}, nil
}

func (s *AuthServer) Login(ctx context.Context, req *pb.LoginRequest) (*pb.LoginResponse, error) {
	var user models.User

	if result := s.Handler.DB.Where(&models.User{Email: req.Email}).First(&user); result.Error != nil {
		return &pb.LoginResponse{
			Status: http.StatusNotFound,
			Error:  "User not found",
		}, nil
	}

	err := CheckPassword(req.Password, user.Password)

	if err != nil {
		return &pb.LoginResponse{
			Status: http.StatusNotFound,
			Error:  "User not found",
		}, nil
	}

	token, _ := s.Jwt.GenerateToken(user)

	return &pb.LoginResponse{
		Status: http.StatusOK,
		Token:  token,
	}, nil
}

func (s *AuthServer) Validate(ctx context.Context, req *pb.ValidateRequest) (*pb.ValidateResponse, error) {
	claims, err := s.Jwt.ValidateToken(req.Token)

	if err != nil {
		return &pb.ValidateResponse{
			Status: http.StatusBadRequest,
			Error:  err.Error(),
		}, nil
	}

	var user models.User

	if result := s.Handler.DB.Where(&models.User{Email: claims.Email}).First(&user); result.Error != nil {
		return &pb.ValidateResponse{
			Status: http.StatusNotFound,
			Error:  "User not found",
		}, nil
	}

	return &pb.ValidateResponse{
		Status: http.StatusOK,
		UserId: user.ID,
	}, nil
}
