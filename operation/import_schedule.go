package operation

import (
	"errors"
	"log"
	"schedulebot/model"
	"strings"
	"time"
)

var (
	ErrNoField = errors.New("one of the fields is not defined")
	ErrInvalidType = errors.New("one of the fields has invalid type")
)

var weekdays = []time.Weekday{
	time.Monday,
	time.Tuesday,
	time.Wednesday,
	time.Thursday,
	time.Friday,
}

var location *time.Location
func init() {
	l, err := time.LoadLocation("Europe/Kiev")
	if err != nil {
		log.Fatal(err)
	}
	location = l
}

func extractArray(data map[string]interface{}, key string) ([]interface{}, error) {
	tmp, ok := data[key]
	if !ok {
		return nil, ErrNoField
	}

	array, ok := tmp.([]interface{})
	if !ok {
		return nil, ErrInvalidType
	}

	return array, nil
}

func extractMap(data map[string]interface{}, key string) (map[string]interface{}, error) {
	tmp, ok := data[key]
	if !ok {
		return nil, ErrNoField
	}

	m, ok := tmp.(map[string]interface{})
	if !ok {
		return nil, ErrInvalidType
	}

	return m, nil
}

func extractString(data map[string]interface{}, key string) (string, error) {
	tmp, ok := data[key]
	if !ok {
		return "", ErrNoField
	}

	str, ok := tmp.(string)
	if !ok {
		return "", ErrInvalidType
	}

	return str, nil
}

func extractInt(data map[string]interface{}, key string) (int, error) {
	tmp, ok := data[key]
	if !ok {
		return 0, ErrNoField
	}

	f, ok := tmp.(float64)
	if !ok {
		return 0, ErrInvalidType
	}

	return int(f), nil
}


func find(array []model.Enumerable, str string) int {
	for i, element := range array {
		if strings.Contains(strings.ToUpper(element.GetName()), strings.ToUpper(str)) {
			return i
		}
	}

	return -1
}

func generateDates(array []interface{}, weekday time.Weekday) []time.Time {
	result := make([]time.Time, 0)

	for _, data := range array {
		dateStr, ok := data.(string)
		if ok {
			date, err := time.ParseInLocation("02.01.2006", dateStr, location)
			if err != nil {
				continue
			}
			result = append(result, date)
		}

		dates, ok := data.(map[string]interface{})
		if ok {
			dateStartStr, err := extractString(dates, "Start")
			if err != nil {
				continue
			}
			dateEndStr, err := extractString(dates, "End")
			if err != nil {
				continue
			}

			dateStart, err := time.ParseInLocation("02.01.2006", dateStartStr, location)
			if err != nil {
				continue
			}
			dateEnd, err := time.ParseInLocation("02.01.2006", dateEndStr, location)
			if err != nil {
				continue
			}

			date := dateStart

			for date.Weekday() != weekday {
				date = date.Add(24 * time.Hour + 3 * time.Second) // add 24 hours + 3 seconds margin for the leap second
			}

			for {
				result = append(result, date)
				date = date.Add(7 * (24 * time.Hour + 3 * time.Second)) // add 7 days
				if date.After(dateEnd) {
					break
				}
			}
		}
	}

	return result
}

func ImportSchedule(scheduleData map[string]interface{}, groupId int64) ([]model.Class, error) {
	result := make([]model.Class, 0)
	group := &model.Group{Id: groupId}

	teachersRaw, err := extractArray(scheduleData, "Teachers")
	if err != nil {
		return nil, err
	}

	teachers := make([]model.Enumerable, 0)

	for _, teacher := range teachersRaw {
		name, ok := teacher.(string)
		if !ok {
			return nil, ErrInvalidType
		}
		teachers = append(teachers, &model.Teacher{Name: name, Group: group})
	}

	subjectsRaw, err := extractArray(scheduleData, "Subjects")
	if err != nil {
		return nil, err
	}

	subjects := make([]model.Enumerable, 0)

	for _, subject := range subjectsRaw {
		name, ok := subject.(string)
		if !ok {
			return nil, ErrInvalidType
		}
		subjects = append(subjects, &model.Subject{Name: name, Group: group})
	}


	classTypesRaw, err := extractArray(scheduleData, "ClassTypes")
	if err != nil {
		return nil, err
	}

	classTypes := make([]model.Enumerable, 0)

	for _, classType := range classTypesRaw {
		name, ok := classType.(string)
		if !ok {
			return nil, ErrInvalidType
		}
		classTypes = append(classTypes, &model.ClassType{Name: name, Group: group})
	}

	roomsRaw, err := extractArray(scheduleData, "Rooms")
	if err != nil {
		return nil, err
	}

	rooms := make([]model.Enumerable, 0)

	for _, room := range roomsRaw {
		name, ok := room.(string)
		if !ok {
			return nil, ErrInvalidType
		}
		rooms = append(rooms, &model.Room{Name: name, Group: group})
	}

	slotsRaw, err := extractArray(scheduleData, "Slots")
	if err != nil {
		return nil, err
	}

	slots := make([]model.Slot, 0)

	for _, slot := range slotsRaw {
		slotMap, ok := slot.(map[string]interface{})
		if !ok {
			return nil, ErrInvalidType
		}

		startStr, err := extractString(slotMap, "Start")
		if err != nil {
			return nil, err
		}
		endStr, err := extractString(slotMap, "End")
		if err != nil {
			return nil, err
		}

		start, err := time.ParseInLocation("15:04", startStr, location)
		if err != nil {
			return nil, err
		}
		end, err := time.ParseInLocation("15:04", endStr, location)
		if err != nil {
			return nil, err
		}

		slots = append(slots, model.Slot{
			Start: start,
			End: end,
			Group: group,
		})
	}

	schedule, err := extractMap(scheduleData, "Schedule")
	if err != nil {
		return nil, err
	}

	for _, weekday := range weekdays {
		weekdaySchedule, err := extractArray(schedule, weekday.String())
		if err != nil {
			continue
		}

		for _, classRaw := range weekdaySchedule {
			class, ok := classRaw.(map[string]interface{})
			if !ok {
				continue
			}

			subject, err := extractString(class, "Subject")
			if err != nil {
				continue
			}
			subjectIndex := find(subjects, subject)
			if subjectIndex == -1 {
				continue
			}

			teacher, err := extractString(class, "Teacher")
			if err != nil {
				continue
			}
			teacherIndex := find(teachers, teacher)
			if teacherIndex == -1 {
				continue
			}

			classType, err := extractString(class, "ClassType")
			if err != nil {
				continue
			}
			classTypeIndex := find(classTypes, classType)
			if classTypeIndex == -1 {
				continue
			}

			room, err := extractString(class, "Room")
			if err != nil {
				continue
			}
			roomIndex := find(rooms, room)
			if roomIndex == -1 {
				continue
			}

			slotIndex, err := extractInt(class, "Slot")
			if err != nil {
				continue
			}

			datesRaw, err := extractArray(class, "Dates")

			dates := generateDates(datesRaw, weekday)

			for _, date := range dates {
				result = append(result, model.Class{
					ClassType: classTypes[classTypeIndex].(*model.ClassType),
					Subject:   subjects[subjectIndex].(*model.Subject),
					Room:      rooms[roomIndex].(*model.Room),
					Teacher:   teachers[teacherIndex].(*model.Teacher),
					Slot:      &slots[slotIndex],
					Group:     group,
					Date:      date,
				})
			}
		}
	}

	return result, nil
}
