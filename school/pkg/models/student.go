package models

type Student struct {
	ID      int64 `json:"id" gorm:"primaryKey"`
	UserID  int64 `json:"user_id"`
	ClassID int64 `json:"class_id"`
	User    User  `gorm:"foreignKey:UserID;references:ID"`
	Class   Class `gorm:"foreignKey:ClassID;references:ID"`
}
