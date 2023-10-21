package db

import (
	"github.com/EliriaT/school-api/school/pkg/models"
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

	db.AutoMigrate(&models.User{})
	db.AutoMigrate(&models.School{})
	db.AutoMigrate(&models.Class{})
	db.AutoMigrate(&models.Student{})

	sqlDB, err := db.DB()
	if err != nil {
		log.Fatalln(err)
	}
	//For testing max concurrency task limit
	sqlDB.SetMaxIdleConns(-2)
	sqlDB.SetMaxOpenConns(1)

	//sqlDB.SetMaxIdleConns(4)
	//sqlDB.SetMaxOpenConns(10)

	return Handler{db}
}
