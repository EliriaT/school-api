package main

import (
	"github.com/EliriaT/school-api/course/internal/db"
	"github.com/EliriaT/school-api/course/internal/services"
	"github.com/EliriaT/school-api/course/internal/services/register"
	"github.com/EliriaT/school-api/course/pkg/client"
	config "github.com/EliriaT/school-api/course/pkg/config"
	"github.com/EliriaT/school-api/course/pkg/pb"
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

	log.Println("Course service started")

	schoolClient := client.InitSchoolServiceClient(config.SchoolUrl)
	authClient := client.InitAuthServiceClient(config.SchoolUrl)
	courseServer := services.CourseServer{Handler: handler, SchoolClient: schoolClient, AuthClient: authClient}

	grpcServer := grpc.NewServer()

	pb.RegisterCourseServiceServer(grpcServer, &courseServer)

	sdClient, err := register.NewSvcDiscoveryClient(config.SDUrl)
	if err != nil {
		log.Fatalf("Could not create course discovery client", err)
	}

	err = sdClient.Register(config.ServiceType, config.MyUrl)
	if err != nil {
		log.Fatalf("Could not register to service discovery", err)
	}

	log.Printf("Course service %s registered to Service Discovery", config.MyUrl)

	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalln("Failed to accept conn:", err)
	}
}
