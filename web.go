package main

import (
	"database/sql"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"runtime"
	"strconv"
	"time"

	_ "github.com/lib/pq"
)

// VEvent provides the grouping of component properties that describe the
// event.
type VEvent interface {
	DTStamp() string
	DTStart() string
	DTEnd() string
	Summary() string
	URL() string
	Organizer() Attendee
	Attendees() []*Attendee
}

// Attendee defines an "attendee" within a calendar component.
type Attendee interface {
	CN() string
}

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

type person struct {
	name  string
	email string
}

func (p *person) CN() string {
	return fmt.Sprintf("%s:mailto:%s", p.name, p.email)
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

type context struct {
	db        *sql.DB
	templates *template.Template
}

func (c *context) index(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	data := struct {
		Year int
	}{
		time.Now().Year(),
	}

	c.render(w, "index", data)
}

func (c *context) calendar(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/calendar")

	year, _ := strconv.Atoi(time.Now().Format("2006"))
	events, err := getCalendarEvents(c.db, year)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}

	c.render(w, "rennen.ics", events)
}

func (c *context) render(w http.ResponseWriter, tmpl string, data interface{}) {
	if err := c.templates.ExecuteTemplate(w, tmpl+".tmpl", data); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func enableCORS(fn http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		scheme := "http"
		if r.TLS != nil {
			scheme = "https"
		}
		w.Header().Set("Access-Control-Allow-Origin", scheme+"://"+r.Host)

		fn(w, r)
	}
}

func track(fn http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if os.Getenv("ENV") != "production" {
			defer func(start time.Time, r *http.Request) {
				elapsed := time.Since(start)
				log.Printf("%s %s %s", r.Method, r.URL, elapsed)
			}(time.Now(), r)
		}

		fn(w, r)
	}
}

func init() {
	runtime.GOMAXPROCS(runtime.NumCPU())
}

func main() {
	db, err := sql.Open("postgres", os.Getenv("DATABASE"))
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	c := context{
		templates: template.Must(template.ParseGlob("./views/*.tmpl")),
		db:        db,
	}

	m := http.NewServeMux()
	m.Handle("/css/", http.FileServer(http.Dir("./static/")))
	m.Handle("/img/", http.FileServer(http.Dir("./static/")))

	m.Handle("/", track(enableCORS(c.index)))
	m.Handle("/rennen.ics", track(enableCORS(c.calendar)))

	s := &http.Server{
		Addr:         ":" + os.Getenv("PORT"),
		Handler:      m,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
		// Go1.8
		// IdleTimeout: 120 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}

	log.Fatal(s.ListenAndServe())
}
