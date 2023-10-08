package main

import (
	"github.com/EliriaT/school-api/school/internal/db"
	"github.com/EliriaT/school-api/school/internal/services/auth"
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

	server := auth.Server{H: handler, Jwt: jwt}

	grpcServer := grpc.NewServer()

	pb.RegisterAuthServiceServer(grpcServer, &server)

	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalln("Failed to accept conn:", err)
	}
}
