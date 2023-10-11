package models

import "time"

type Mark struct {
	ID        int64     `json:"id"`
	CourseID  int64     `json:"course_id"`
	Course    Course    `gorm:"foreignKey:CourseID;references:ID"`
	MarkDate  time.Time `json:"mark_date"`
	IsAbsent  bool      `json:"is_absent"`
	Mark      int32     `json:"mark"`
	StudentID int64     `json:"student_id"`
}
