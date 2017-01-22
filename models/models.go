package models

import (
	"net/url"
	"time"
)

// Event represents a single entry in database. Includes link to participants
// of an event.
type Event struct {
	ID       int
	Title    string
	Date     *time.Time
	URL      *url.URL
	Distance int
	People   []Person
}

// Person represents a participant of an event.
type Person struct {
	ID        int
	FirstName string
	LastName  string
	Email     string
}

// Name returns a persons first and lastname concatinated.
func (p *Person) Name() string {
	return p.FirstName + " " + p.LastName
}

// SELECT e.id, e.date, e.title, e.url, e.distance, e.created_at, p.first_name || ' ' || p.last_name AS name, p.email
// FROM events AS e
// LEFT JOIN participations AS t ON e.id = t.event_id
// LEFT JOIN people AS p ON t.person_id = p.id
// WHERE e.date BETWEEN '2015-01-01' AND '2016-01-01'
// ORDER BY e.date, e.id, name
// ;
