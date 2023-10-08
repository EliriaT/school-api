package model

import "time"

type UserID int64
type CourseID int64

type Course struct {
	ID        int64  `json:"id,omitempty"`
	Name      string `json:"name"`
	TeacherID UserID `json:"teacher_id"`
	ClassID   int64  `json:"class_id"`
}

type Lesson struct {
	ID        int64     `json:"id"`
	Name      string    `json:"name"`
	CourseID  int64     `json:"course_id"`
	StartHour time.Time `json:"start_hour"`
	EndHour   time.Time `json:"end_hour"`
	WeekDay   string    `json:"week_day"`
	Classroom string    `json:"classroom"`
	TeacherID UserID    `json:"teacher_id,omitempty"`
	ClassID   int64     `json:"class_id,omitempty"`
}
