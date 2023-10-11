package main

import (
	"github.com/EliriaT/school-api/school/internal/db"
	"github.com/EliriaT/school-api/school/internal/services/auth"
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
		log.Fatalf("Could not log config", err)
	}
	handler := db.Init(config.DBUrl)
	jwt := auth.JwtWrapper{
		SecretKey:       config.SecretKey,
		Issuer:          "school-aoi",
		ExpirationHours: 24 * 365,
	}

	listener, err := net.Listen("tcp", config.Port)

	log.Println("School service started")

	authServer := auth.AuthServer{Handler: handler, Jwt: jwt}
	schoolServer := school.SchoolServer{Handler: handler}

	grpcServer := grpc.NewServer()

	pb.RegisterAuthServiceServer(grpcServer, &authServer)
	pb.RegisterSchoolServiceServer(grpcServer, &schoolServer)

	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalln("Failed to accept conn:", err)
	}
}
