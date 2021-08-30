package model

import "github.com/beego/beego/v2/client/orm"

func init() {
	orm.RegisterModel(
		new(Class),
		new(ClassType),
		new(Group),
		new(Room),
		new(Subject),
		new(Teacher),
		new(Slot),
	)
}
