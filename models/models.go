package models

import (
	"database/sql"
	"time"
)

// GetCalendarEvents returns an array of all events for that given year
// including all known participants.
func GetCalendarEvents(db *sql.DB, year int) (events []event, err error) {
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
		return
	}
	defer rows.Close()

	var lastEvent event
	var name, email sql.NullString
	for rows.Next() {
		var e event
		if err = rows.Scan(&e.id, &e.title, &e.date, &e.createdAt, &e.url, &e.distance, &name, &email); err != nil {
			return
		}

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
