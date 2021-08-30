package model

type Group struct {
	Id int64
	Name string
	ChatId int64
}

func (e *Group) GetName() string {
	return e.Name
}

func (e *Group) SetName(name string) {
	e.Name = name
}
