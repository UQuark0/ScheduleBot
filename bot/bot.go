package bot

import (
	"github.com/beego/beego/v2/client/orm"
	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api"
)

type Bot struct {
	api *tgbotapi.BotAPI
	db orm.Ormer
}

func NewBot(token string, chatId int64, db orm.Ormer) (*Bot, error) {
	api, err := tgbotapi.NewBotAPI(token)
	if err != nil {
		return nil, err
	}

	return &Bot{
		api: api,
		db: db,
	}, nil
}
