package main

import "fmt"

type person struct {
	name  string
	email string
}

func (p *person) CN() string {
	return fmt.Sprintf("%s:mailto:%s", p.name, p.email)
}
