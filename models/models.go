package models

import (
	"database/sql"
	"fmt"
	"net/url"
	"time"
)

// Event represents a single entry in database. Includes link to participants
// of an event.
type Event struct {
	ID        int
	Title     string
	Date      *time.Time
	CreatedAt *time.Time
	URL       *url.URL
	Distance  int
	People    []Person
}

// Person represents a participant of an event.
type Person struct {
	ID    int
	Name  string
	Email string
}

// GetCalendarEvents returns an array of all events for that given year
// including all known participants.
func GetCalendarEvents(db *sql.DB, year int) ([]Event, error) {
	query := `
	SELECT
		e.id, e.title, e.url, e.distance, e.created_at,
		p.first_name || " " || p.last_name AS name, p.email
	FROM
		events AS e
		LEFT JOIN participations AS t ON e.id = t.event_id
		LEFT JOIN people AS p ON t.person_id = p.id
	WHERE
		e.date BETWEEN "?" AND "?"
	ORDER BY
		e.date, e.id, p.first_name, p.last_name
	`
	rows, err := db.Query(query, fmt.Sprintf("%v-01-01", year), fmt.Sprintf("%v-01-01", year+1))
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	//c.db.Query("SELECT id, created_at, date, title, url FROM events")
	return nil, nil
}

// SELECT e.id, e.date, e.title, e.url, e.distance, e.created_at, p.first_name || ' ' || p.last_name AS name, p.email
// FROM events AS e
// LEFT JOIN participations AS t ON e.id = t.event_id
// LEFT JOIN people AS p ON t.person_id = p.id
// WHERE e.date BETWEEN '2015-01-01' AND '2016-01-01'
// ORDER BY e.date, e.id, name
// ;
