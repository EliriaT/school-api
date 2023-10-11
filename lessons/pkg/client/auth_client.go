package client

import (
	"context"
	"github.com/EliriaT/school-api/lessons/pkg/pb"
	"google.golang.org/grpc"
	"log"
)

type AuthServiceClient struct {
	Client pb.AuthServiceClient
}

func InitAuthServiceClient(url string) AuthServiceClient {
	conn, err := grpc.Dial(url, grpc.WithInsecure())
	if err != nil {
		log.Println("Could not connect to school service")
	}

	client := AuthServiceClient{Client: pb.NewAuthServiceClient(conn)}
	return client
}
func (s *AuthServiceClient) GetUser(classId int64) (*pb.UserResponse, error) {
	request := &pb.UserID{Id: classId}
	return s.Client.GetUser(context.Background(), request)
}
