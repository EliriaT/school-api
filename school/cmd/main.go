package main

import (
	"github.com/EliriaT/school-api/school/internal/controller/school"
	httphandler "github.com/EliriaT/school-api/school/internal/handler/http"
	"github.com/EliriaT/school-api/school/internal/repository/memory"
	"log"
	"net/http"
)

func main() {
	log.Println("Starting the movie metadata service")

	repo := memory.New()
	ctrl := school.New(repo)
	h := httphandler.New(ctrl)
	http.Handle("/school", http.HandlerFunc(h.GetSchool))
	if err := http.ListenAndServe(":8081", nil); err != nil {
		panic(err)
	}
}
