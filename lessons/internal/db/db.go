package db

import (
	"github.com/EliriaT/school-api/lessons/pkg/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"log"
)

type Handler struct {
	DB *gorm.DB
}

func Init(url string) Handler {
	db, err := gorm.Open(postgres.Open(url), &gorm.Config{})

	if err != nil {
		log.Fatalln(err)
	}

	db.AutoMigrate(&models.Course{})
	db.AutoMigrate(&models.Lesson{})
	db.AutoMigrate(&models.Mark{})

	return Handler{db}
}
