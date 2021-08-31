package bot

import (
	"fmt"
	"github.com/beego/beego/v2/client/orm"
	"github.com/go-co-op/gocron"
	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api"
	"log"
	"math"
	"schedulebot/model"
	"schedulebot/service"
)

const messageFormat =
`Увага <code>%s</code>!
За <code>%d</code> хвилин починається пара!
Дисципліна: <code>%s</code>
Тип заняття: <code>%s</code>
Викладач: <code>%s</code>
Аудиторія: %s
`

type Bot struct {
	api *tgbotapi.BotAPI
	db orm.Ormer
}

func NewBot(token string, chatId int64, db orm.Ormer) (*Bot, error) {
	api, err := tgbotapi.NewBotAPI(token)
	if err != nil {
		return nil, err
	}

	bot := Bot{
		api: api,
		db: db,
	}

	scheduler := gocron.NewScheduler(service.Location)

	_, err = scheduler.Every(1).Minute().Do(func() {
		err := bot.CheckReports()
		if err != nil {
			log.Print(err)
		}
	})

	if err != nil {
		return nil, err
	}

	scheduler.StartAsync()

	return &bot, nil
}

func (b *Bot) CheckReports() error {
	reports, err := b.LoadReports()
	if err != nil {
		return err
	}
	return b.AnnounceReports(reports)
}

func (b *Bot) AnnounceReports(reports []model.ClassReport) error {
	tx, err := b.db.Begin()
	if err != nil {
		return err
	}

	for _, report := range reports {
		text := fmt.Sprintf(messageFormat,
			report.GroupName,
			int(math.Round(report.Delay.Minutes())),
			report.SubjectName,
			report.ClassTypeName,
			report.TeacherName,
			report.RoomName,
		)

		message := tgbotapi.NewMessage(report.ChatId, text)
		message.ParseMode = tgbotapi.ModeHTML
		_, err = b.api.Send(message)
		if err != nil {
			_ = tx.Rollback()
			return err
		}

		_, err = tx.Update(&model.Class{
			Id:        report.Id,
			Announced: true,
		}, "Announced")
		if err != nil {
			_ = tx.Rollback()
			return err
		}

		log.Printf("Announced class #%d", report.Id)
	}

	return tx.Commit()
}

func (b *Bot) LoadReports() ([]model.ClassReport, error) {
	const query = `
		SELECT
			class.id,
			"group".chat_id AS chat_id,
			"group".name AS group_name,
			subject.name AS subject_name,
			class_type.name AS class_type_name,
			teacher.name AS teacher_name,
			room.name AS room_name,
			EXTRACT(EPOCH FROM (slot.start - now()::time))::bigint * 1000000000 AS delay
		FROM class
		LEFT JOIN class_type ON class.class_type_id = class_type.id
		LEFT JOIN "group" ON class.group_id = "group".id
		LEFT JOIN room ON class.room_id = room.id
		LEFT JOIN slot ON class.slot_id = slot.id
		LEFT JOIN subject ON class.subject_id = subject.id
		LEFT JOIN teacher ON class.teacher_id = teacher.id
		WHERE
			NOT announced AND
			(slot.start - now()::time) BETWEEN '0 minutes' AND '10 minutes' AND
			class.date = now()::date
	`

	reports := make([]model.ClassReport, 0)

	_, err := b.db.Raw(query).QueryRows(&reports)

	return reports, err
}