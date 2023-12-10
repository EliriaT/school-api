package main

import (
	"github.com/EliriaT/school-api/course/internal/db"
	"github.com/EliriaT/school-api/course/internal/services"
	"github.com/EliriaT/school-api/course/internal/services/register"
	"github.com/EliriaT/school-api/course/pkg/client"
	config "github.com/EliriaT/school-api/course/pkg/config"
	"github.com/EliriaT/school-api/course/pkg/pb"
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

	http.Handle("/metrics", promhttp.HandlerFor(reg, promhttp.HandlerOpts{}))
	go func() {
		if err := http.ListenAndServe(":2114", nil); err != nil {
			log.Fatal(err)
		} else {
			log.Println("HTTP server listening at 2114")
		}
	}()

	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalln("Failed to accept conn:", err)
	}
}
