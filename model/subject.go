package model

type Subject struct {
	Id int64
	Name string
	Group *Group `orm:"rel(fk)"`
}

func (e *Subject) GetName() string {
	return e.Name
}

func (e *Subject) SetName(name string) {
	e.Name = name
}