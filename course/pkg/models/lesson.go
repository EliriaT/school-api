package models

type Lesson struct {
	ID        int64  `json:"id"`
	Name      string `json:"name"`
	CourseID  int64  `json:"course_id"`
	Course    Course `gorm:"foreignKey:CourseID;references:ID"`
	StartHour string `json:"start_hour"`
	EndHour   string `json:"end_hour"`
	WeekDay   string `json:"week_day"`
	Classroom string `json:"classroom"`
}
