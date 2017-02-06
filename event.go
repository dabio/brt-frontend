package main

import (
	"database/sql"
	"fmt"
	"time"
)

type event struct {
	id        int
	title     string
	date      *time.Time
	createdAt *time.Time
	createdBy *person
	url       string
	distance  int
	people    []*person
}

// Property defines the persistent, globally unique identifier for the calendar
// component.
func (e *event) UID() string {
	return fmt.Sprintf("%s-%d", e.DTStamp(), e.id)
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

// Organizer defines th eorganizer of the calendar component.
func (e *event) Organizer() Attendee {
	return e.createdBy
}

// Attendees defines a list of "attendees" within a calendar component.
func (e *event) Attendees() []*person {
	return e.people
}

func getCalendarEvents(db *sql.DB, year int) (events []event, err error) {
	query := `
	SELECT
		e.id, e.title, e.date, e.created_at, e.url, e.distance,
		p.first_name || ' ' || p.last_name AS name, p.email,
		o.first_name || ' ' || o.last_name AS oname, o.email AS oemail
	FROM
		events AS e
		LEFT JOIN people AS o ON e.person_id = o.id
		LEFT JOIN participations AS t ON e.id = t.event_id
		LEFT JOIN people AS p ON t.person_id = p.id
	WHERE
		e.date BETWEEN $1 AND $2
	ORDER BY
		e.date, e.id, p.first_name, p.last_name
	`
	begin := time.Date(year, 1, 1, 0, 0, 0, 0, time.UTC)
	rows, err := db.Query(query, begin, begin.AddDate(1, 0, 0))
	if err != nil {
		return
	}
	defer rows.Close()

	var lastEvent event
	var name, email sql.NullString
	for rows.Next() {
		var e event
		var o person
		err = rows.Scan(
			&e.id,
			&e.title,
			&e.date,
			&e.createdAt,
			&e.url,
			&e.distance,
			&name,
			&email,
			&o.name,
			&o.email)
		if err != nil {
			return
		}
		e.createdBy = &o

		// Init lastEvent when none was set before.
		if lastEvent.id == 0 {
			lastEvent = e
		}

		if e.id != lastEvent.id {
			events = append(events, lastEvent)
			lastEvent = e
		}

		if name.Valid && email.Valid {
			lastEvent.people = append(lastEvent.people, &person{name: name.String, email: email.String})
		}
	}
	if err = rows.Err(); err != nil {
		return
	}
	if lastEvent.id != 0 {
		events = append(events, lastEvent)
	}

	return
}
