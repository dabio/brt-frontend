package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
)

func index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello World")
}

func calendar(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Calendar")
}

func main() {
	var (
		port = flag.String("port", "8080", "listen port")
	)
	flag.Parse()

	http.HandleFunc("/", index)
	http.HandleFunc("/rennen.ics", calendar)

	log.Println("listening on port " + *port)
	log.Fatal(http.ListenAndServe(":"+*port, nil))
}
