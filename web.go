package main

import (
	"database/sql"
	"html/template"
	"log"
	"net/http"
	"os"
	"runtime"
	"strconv"
	"time"

	"github.com/dabio/brt-go/models"
	_ "github.com/lib/pq"
)

type context struct {
	db        *sql.DB
	templates *template.Template
}

func (c *context) index(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	c.render(w, "index", nil)
}

func (c *context) calendar(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/calendar")

	year, _ := strconv.Atoi(time.Now().Format("2006"))
	events, err := models.GetCalendarEvents(c.db, year)
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

func track(next http.Handler, env string) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if env != "production" {
			defer func(start time.Time, r *http.Request) {
				elapsed := time.Since(start)
				log.Printf("%s %s %s", r.Method, r.URL, elapsed)
			}(time.Now(), r)
		}

		next.ServeHTTP(w, r)
	})
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
	env := os.Getenv("ENV")

	m := http.NewServeMux()
	m.Handle("/css/", http.FileServer(http.Dir("./static/")))
	m.Handle("/img/", http.FileServer(http.Dir("./static/")))

	m.Handle("/rennen.ics", track(http.HandlerFunc(c.calendar), env))
	m.Handle("/", track(http.HandlerFunc(c.index), env))

	log.Fatal(http.ListenAndServe(":"+os.Getenv("PORT"), m))
}
