package model

type Teacher struct {
	Id int64
	Name string
	Group *Group `orm:"rel(fk)"`
}

func (e *Teacher) GetName() string {
	return e.Name
}

func (e *Teacher) SetName(name string) {
	e.Name = name
}