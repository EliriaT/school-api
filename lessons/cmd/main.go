package main

import (
	"github.com/EliriaT/school-api/lessons/internal/db"
	"github.com/EliriaT/school-api/lessons/internal/services"
	"github.com/EliriaT/school-api/lessons/pkg/client"
	config "github.com/EliriaT/school-api/lessons/pkg/config"
	"github.com/EliriaT/school-api/lessons/pkg/pb"
	"google.golang.org/grpc"
	"log"
	"net"
)

func main() {
	config, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Could not log config", err)
	}
	handler := db.Init(config.DBUrl)

	listener, err := net.Listen("tcp", config.Port)
	if err != nil {
		log.Fatalf("Could not open tcp conn", err)
	}

	log.Println("Lessons service started")

	schoolClient := client.InitSchoolServiceClient(config.SchoolUrl)
	authClient := client.InitAuthServiceClient(config.SchoolUrl)
	courseServer := services.CourseServer{Handler: handler, SchoolClient: schoolClient, AuthClient: authClient}

	grpcServer := grpc.NewServer()

	pb.RegisterCourseServiceServer(grpcServer, &courseServer)

	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalln("Failed to accept conn:", err)
	}
}
