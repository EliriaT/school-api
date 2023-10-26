package main

import (
	"github.com/EliriaT/school-api/school/internal/db"
	"github.com/EliriaT/school-api/school/internal/services/auth"
	"github.com/EliriaT/school-api/school/internal/services/register"
	"github.com/EliriaT/school-api/school/internal/services/school"
	config "github.com/EliriaT/school-api/school/pkg/config"
	"github.com/EliriaT/school-api/school/pkg/pb"
	"google.golang.org/grpc"
	"log"
	"net"
)

func main() {
	config, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Could not log config %v", err)
	}
	handler := db.Init(config.DBUrl)
	jwt := auth.JwtWrapper{
		SecretKey:       config.SecretKey,
		Issuer:          "school-aoi",
		ExpirationHours: 24 * 365,
	}

	listener, err := net.Listen("tcp", config.Port)
	if err != nil {
		log.Fatalf("Could not open tcp connection for service  %v", err)
	}

	log.Println("School service started")

	authServer := auth.AuthServer{Handler: handler, Jwt: jwt}
	schoolServer := school.SchoolServer{Handler: handler}

	grpcServer := grpc.NewServer()

	pb.RegisterAuthServiceServer(grpcServer, &authServer)
	pb.RegisterSchoolServiceServer(grpcServer, &schoolServer)

	sdClient, err := register.NewSvcDiscoveryClient(config.SDUrl)
	if err != nil {
		log.Fatalf("Could not create service discovery client  %v", err)
	}

	err = sdClient.Register(config.ServiceType, config.MyUrl)
	if err != nil {
		log.Fatalf("Could not register to service discovery  %v", err)
	}

	log.Printf("School service %s registered to Service Discovery", config.MyUrl)

	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("Failed to accept conn:  %v", err)
	}
}
