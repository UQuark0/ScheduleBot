package model

import "time"

type ClassReport struct {
	Id int64
	ChatId int64
	GroupName string
	SubjectName string
	ClassTypeName string
	TeacherName string
	RoomName string
	Delay time.Duration
}
