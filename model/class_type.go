package model

type ClassType struct {
	Id int64
	Name string
	Group *Group `orm:"rel(fk)"`
}

func (e *ClassType) GetName() string {
	return e.Name
}

func (e *ClassType) SetName(name string) {
	e.Name = name
}