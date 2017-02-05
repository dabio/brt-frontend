package main

// VEvent provides the grouping of component properties that describe the
// event.
type VEvent interface {
	DTStamp() string
	DTStart() string
	DTEnd() string
	Summary() string
	URL() string
	Attendees() []*Attendee
}

// Attendee defines an "attendee" within a calendar component.
type Attendee interface {
	CN() string
}
