package main

import (
	"github.com/EliriaT/school-api/lessons/internal/controller/course"
	httphandler "github.com/EliriaT/school-api/lessons/internal/handler/http"
	"github.com/EliriaT/school-api/lessons/internal/repository/memory"
	"log"
	"net/http"
)

func main() {
	log.Println("Starting the rating service")
	repo := memory.New()
	ctrl := course.New(repo)
	h := httphandler.New(ctrl)
	http.Handle("/course", http.HandlerFunc(h.Handle))
	if err := http.ListenAndServe(":8082", nil); err != nil {
		panic(err)
	}
}
