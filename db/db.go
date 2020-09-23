package db

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq" //importing blank as per the package recommendation.
	"os"
)

var (
	db   *sql.DB
)

type Book struct {
	ID int32
	Title string
	Author string
	Available bool
}


func Start() {
	var err error

	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+"password=%s dbname=%s sslmode=disable", "localhost", 5432, "postgres", os.Getenv("POSTGRES_PASS"), "library")

	db, err = sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}

	if err = db.Ping(); err != nil {
		panic(err)
	}
	fmt.Println("SQL Connected")
}

func (b *Book) NewBook() error {
	msg := `
	INSERT INTO books (title, author)
	VALUES ($1, $2)		
	`

	if _, err := db.Exec(msg, b.Title, b.Author); err != nil {
		return err
	}

	return nil
}

func createTable()  {
	msg := `CREATE TABLE books (
	  id SERIAL PRIMARY KEY,
	  author TEXT DEFAULT '',
	  title TEXT NOT NULL ,
	  available BOOLEAN DEFAULT true
	);`

	if _, err := db.Exec(msg); err != nil {
		fmt.Println("error creating table", err)
	}
}