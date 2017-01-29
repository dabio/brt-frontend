package models

import (
	"database/sql"
	"time"
)

// Event represents a single entry in database. Includes link to participants
// of an event.
type Event struct {
	ID        int
	Title     string
	Date      *time.Time
	CreatedAt *time.Time
	URL       string
	Distance  int
	People    []Person
}

// Person represents a participant of an event.
type Person struct {
	Name  string
	Email string
}

// Vevent provides the grouping of component properties that describe the
// event.
type Vevent interface {
	DtStamp() string
	DtStart() string
	DtEnd() string
	Summary() string
	URL() string
	Attendees() []Attendee
}

// Attendee defines an "attendee" within a calendar component.
type Attendee interface {
	CN() string
}

// DtStamp specifies the date and time the instance of the iCalendar object was
// created.
func (e Event) CalendarDStamp() string {
	return e.CreatedAt.Format("20060102T150405Z")
}

// CalendarDStart returns the start event date formatted for the use in .ics
// calendar format.
func (e Event) CalendarDStart() string {
	return e.Date.Format("20060102")
}

// CalendarDEnd returns the next day of the event. For use in .ics calendar
// format to mark the ending date.
func (e Event) CalendarDEnd() string {
	return e.Date.AddDate(0, 0, 1).Format("20060102")
}

// GetCalendarEvents returns an array of all events for that given year
// including all known participants.
func GetCalendarEvents(db *sql.DB, year int) ([]Event, error) {
	query := `
	SELECT
		e.id, e.title, e.date, e.created_at, e.url, e.distance,
		p.first_name || ' ' || p.last_name AS name, p.email
	FROM
		events AS e
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
		return nil, err
	}
	defer rows.Close()

	var events []Event
	var lastEvent Event
	var name, email sql.NullString
	for rows.Next() {
		var e Event
		if err = rows.Scan(&e.ID, &e.Title, &e.Date, &e.CreatedAt, &e.URL, &e.Distance, &name, &email); err != nil {
			return nil, err
		}

		// Init lastEvent when none was set before.
		if lastEvent.ID == 0 {
			lastEvent = e
		}

		if e.ID != lastEvent.ID {
			events = append(events, lastEvent)
			lastEvent = e
		}

		if name.Valid && email.Valid {
			lastEvent.People = append(lastEvent.People, Person{Name: name.String, Email: email.String})
		}
	}
	if err = rows.Err(); err != nil {
		return nil, err
	}
	if lastEvent.ID != 0 {
		events = append(events, lastEvent)
	}

	return events, nil
}
