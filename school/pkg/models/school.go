package models

type School struct {
	ID   int64  `json:"id" gorm:"primaryKey"`
	Name string `json:"name"`
}
