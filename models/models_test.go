package models

import "testing"

func TestPersonName(t *testing.T) {
	p := &Person{FirstName: "First", LastName: "Last"}

	want := `First Last`
	if got := p.Name(); got != want {
		t.Errorf("wrong name: got %v want %v", got, want)
	}
}
