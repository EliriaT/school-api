package models

type User struct {
	ID       int64  `json:"id" gorm:"primaryKey"`
	Email    string `json:"email"`
	Password string `json:"password"`
	Name     string `json:"name"`
	SchoolId int64  `json:"school_id"`
	ClassId  int64  `json:"class_id"`
	RoleId   int64  `json:"role_id"`
	School   School `gorm:"foreignKey:SchoolId"`
	Class    Class  `gorm:"foreignKey:HeadTeacherId;references:ID"`
}
