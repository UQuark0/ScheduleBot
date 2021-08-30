package model

type Room struct {
	Id int64
	Name string
	Group *Group `orm:"rel(fk)"`
}

func (e *Room) GetName() string {
	return e.Name
}

func (e *Room) SetName(name string) {
	e.Name = name
}