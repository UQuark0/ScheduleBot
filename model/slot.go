package model

import "time"

type Slot struct {
	Id int64
	Start time.Time `orm:"type(datetime)"`
	End time.Time `orm:"type(datetime)"`
	Group *Group `orm:"rel(fk)"`
}
