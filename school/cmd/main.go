package main

import (
	"github.com/EliriaT/school-api/school/internal/db"
	"github.com/EliriaT/school-api/school/internal/services/auth"
	"github.com/EliriaT/school-api/school/internal/services/register"
	"github.com/EliriaT/school-api/school/internal/services/school"
	config "github.com/EliriaT/school-api/school/pkg/config"
	"github.com/EliriaT/school-api/school/pkg/pb"
	grpcprom "github.com/grpc-ecosystem/go-grpc-middleware/providers/prometheus"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"google.golang.org/grpc"
	"log"
	"net"
	"net/http"
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

	authServer := auth.AuthServer{Handler: handler, Jwt: jwt, Config: config}
	schoolServer := school.SchoolServer{Handler: handler}

	srvMetrics := grpcprom.NewServerMetrics(
		grpcprom.WithServerHandlingTimeHistogram(
			grpcprom.WithHistogramBuckets([]float64{0.001, 0.01, 0.1, 0.3, 0.6, 1, 3, 6, 9, 20, 30, 60, 90, 120}),
		),
	)

	grpcServer := grpc.NewServer(grpc.ChainUnaryInterceptor(
		srvMetrics.UnaryServerInterceptor(),
	))

	reg := prometheus.NewRegistry()
	reg.MustRegister(srvMetrics)
	srvMetrics.InitializeMetrics(grpcServer)

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

	http.Handle("/metrics", promhttp.HandlerFor(reg, promhttp.HandlerOpts{}))
	go func() {
		if err := http.ListenAndServe(":2112", nil); err != nil {
			log.Fatal(err)
		} else {
			log.Println("HTTP server listening at 2112")
		}
	}()

	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("Failed to accept conn:  %v", err)
	}
}
