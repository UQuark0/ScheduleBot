package model

import "time"

type Class struct {
	Id int64
	ClassType *ClassType `orm:"rel(fk)"`
	Group *Group `orm:"rel(fk)"`
	Subject *Subject `orm:"rel(fk)"`
	Room *Room `orm:"rel(fk)"`
	Teacher *Teacher `orm:"rel(fk)"`
	Slot *Slot `orm:"rel(fk)"`
	Date time.Time `orm:"type(date)"`
	Announced bool
}