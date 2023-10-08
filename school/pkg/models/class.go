package models

type Class struct {
	ID            int64  `json:"id" gorm:"primaryKey"`
	Name          string `json:"name"`
	HeadTeacherId int64  `json:"head_teacher_id"`
	SchoolId      int64  `json:"school_id"`
	School        School `gorm:"foreignKey:SchoolId"`
}
