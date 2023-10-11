package client

import (
	"context"
	"github.com/EliriaT/school-api/lessons/pkg/pb"
	"google.golang.org/grpc"
	"log"
)

type SchoolServiceClient struct {
	Client pb.SchoolServiceClient
}

func InitSchoolServiceClient(url string) SchoolServiceClient {
	conn, err := grpc.Dial(url, grpc.WithInsecure())
	if err != nil {
		log.Println("Could not connect to school service")
	}

	client := SchoolServiceClient{Client: pb.NewSchoolServiceClient(conn)}
	return client
}
func (s *SchoolServiceClient) GetClass(classId int64) (*pb.ClassResponse, error) {
	request := &pb.ClassID{Id: classId}
	return s.Client.GetClass(context.Background(), request)
}
