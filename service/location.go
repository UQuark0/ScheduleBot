package service

import (
	"log"
	"time"
)

var Location *time.Location

func init() {
	location, err := time.LoadLocation("Europe/Kiev")
	if err != nil {
		log.Fatal(err)
	}
	Location = location
}