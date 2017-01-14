package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

func index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello World")
}

func calendar(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Calendar")
}

func timeTrack(start time.Time, r *http.Request) {
	elapsed := time.Since(start)
	log.Printf("%s %s %s", r.Method, r.URL, elapsed)
}

func track(fn http.HandlerFunc, env string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if env != "production" {
			defer timeTrack(time.Now(), r)
		}

		fn(w, r)
	}
}

func main() {
	var (
		port = os.Getenv("PORT")
		env  = os.Getenv("ENV")
	)

	m := http.NewServeMux()
	m.Handle("/", track(index, env))
	m.Handle("/rennen.ics", track(calendar, env))

	log.Fatal(http.ListenAndServe(":"+port, m))
}
