package models

type Course struct {
	ID        int64    `json:"id" gorm:"primaryKey"`
	Name      string   `json:"name"`
	TeacherID int64    `json:"teacher_id"`
	ClassID   int64    `json:"class_id"`
	Dates     []string `json:"dates"`
	Marks     []Mark   `gorm:"foreignKey:CourseID;references:ID"`
}
