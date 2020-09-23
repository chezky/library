package routes

import (
	"fmt"
	"net/http"

	"github.com/chezky/library/db"

	"github.com/gorilla/schema"
)

var decoder = schema.NewDecoder()

func NewBookHandler(w http.ResponseWriter, r *http.Request)  {
	var b db.Book

	if err := r.ParseForm(); err != nil {
		fmt.Println(err)
		return
	}

	if err := decoder.Decode(&b, r.PostForm); err != nil {
		fmt.Println("error marshaling into struct", err)// Handle error
	}

	if err := b.NewBook(); err != nil{
		fmt.Println("error inserting book into db", b.Title, err)
	}

	fmt.Println("data is,", b.Title)
	fmt.Fprint(w, "success")
}