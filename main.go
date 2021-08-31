package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"github.com/beego/beego/v2/client/orm"
	_ "github.com/lib/pq"
	"log"
	"os"
	"schedulebot/bot"
	"schedulebot/model"
	_ "schedulebot/model"
	"schedulebot/operation"
	"strings"
)

const dbName = "default"

func main() {
	dsn := flag.String("dsn", "", "data source name")
	schedule := flag.String("schedule", "", "schedule JSON file")
	group := flag.Int64("group", 0, "group id")
	clean := flag.Bool("clean", false, "clean group's schedule")
	token := flag.String("token", "", "telegram bot API token")
	channel := flag.String("channel", "", "public channel tag to gather chat id")

	flag.Parse()

	err := orm.RegisterDataBase(dbName, "postgres", *dsn)
	if err != nil {
		log.Fatal(err)
	}

	err = orm.RunSyncdb(dbName, false, true)
	if err != nil {
		log.Fatal(err)
	}

	db := orm.NewOrm()

	if *group != 0 {
		if *schedule != "" {
			log.Print("Starting schedule import")

			scheduleFile, err := os.Open(*schedule)
			if err != nil {
				log.Fatal(err)
			}

			scheduleData := make(map[string]interface{})

			log.Print("Decoding JSON")

			err = json.NewDecoder(scheduleFile).Decode(&scheduleData)
			if err != nil {
				log.Fatal(err)
			}

			log.Print("Importing schedule")

			classes, err := operation.ImportSchedule(scheduleData, *group)
			if err != nil {
				log.Fatal(err)
			}

			log.Print("Storing schedule")

			err = operation.StoreSchedule(classes, db)
			if err != nil {
				log.Fatal(err)
			}

			log.Print("Done")

			return
		}

		if *clean {
			g := model.Group{Id: *group}
			err = db.Read(&g)
			if err != nil {
				log.Fatal(err)
			}

			log.Printf("Are you sure you want to delete group #%d '%s'? [y/N]", g.Id, g.Name)
			answer := ""
			_, err = fmt.Scanln(&answer)
			if err != nil {
				log.Fatal(err)
			}
			answer = strings.Trim(answer, "\n")

			if answer == "y" || answer == "Y" {
				_, err = db.Delete(&g)
				if err != nil {
					log.Fatal(err)
				}
				log.Print("Deleted")
			} else {
				log.Print("Delete aborted")
			}
			return
		}
	}

	if *token != "" {
		b, err := bot.NewBot(*token, 0, db)
		if err != nil {
			log.Fatal(err)
		}

		if *channel != "" {
			chatId, err := b.GatherChatId(*channel)
			if err != nil {
				log.Fatal(err)
			}
			log.Printf("Chat ID: %d", chatId)
			return
		}

		select {}
	}
}