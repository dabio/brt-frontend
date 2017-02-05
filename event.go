package main

import (
	"fmt"
	"time"
)

type event struct {
	id        int
	title     string
	date      *time.Time
	createdAt *time.Time
	url       string
	distance  int
	people    []*person
}

// DTStamp specifies the date and time the instance of the iCalendar object
// was created.
func (e *event) DTStamp() string {
	return e.createdAt.Format("20060102T150405Z")
}

// DTStart returns the start event date formatted for the use in .ics calendar
// format.
func (e *event) DTStart() string {
	return e.date.Format("20060102")
}

// DTEnd returns the next day of the event. For use in .ics calendar format
// to mark the ending date.
func (e *event) DTEnd() string {
	return e.date.AddDate(0, 0, 1).Format("20060102")
}

// Summary defines a short summary for the calendar component.
func (e *event) Summary() string {
	return fmt.Sprintf("%s\\, %dkm", e.title, e.distance)
}

// URL defines an URL associated with the iCalendar object.
func (e *event) URL() string {
	return e.url
}

// Attendees defines a list of "attendees" within a calendar component.
func (e *event) Attendees() []*person {
	return e.people
}
