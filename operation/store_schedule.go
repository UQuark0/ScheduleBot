package operation

import (
	"github.com/beego/beego/v2/client/orm"
	"schedulebot/model"
)

func StoreSchedule(classes []model.Class, db orm.Ormer) error {
	tx, err := db.Begin()
	if err != nil {
		_ = tx.Rollback()
		return err
	}

	for _, class := range classes {
		if class.Subject.Id == 0 {
			_, err := tx.Insert(class.Subject)
			if err != nil {
				_ = tx.Rollback()
				return err
			}
		}
		if class.ClassType.Id == 0 {
			_, err := tx.Insert(class.ClassType)
			if err != nil {
				_ = tx.Rollback()
				return err
			}
		}
		if class.Teacher.Id == 0 {
			_, err := tx.Insert(class.Teacher)
			if err != nil {
				_ = tx.Rollback()
				return err
			}
		}
		if class.Room.Id == 0 {
			_, err := tx.Insert(class.Room)
			if err != nil {
				_ = tx.Rollback()
				return err
			}
		}
		if class.Slot.Id == 0 {
			_, err := tx.Insert(class.Slot)
			if err != nil {
				_ = tx.Rollback()
				return err
			}
		}

		_, err := tx.Insert(&class)
		if err != nil {
			_ = tx.Rollback()
			return err
		}
	}

	return tx.Commit()
}
