package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type message struct {
	Msg string `json:"msg,omitempty"`
}

func message_to_json(message *message) ([]byte, error) {
	return json.Marshal(message)
}

func server_one(w http.ResponseWriter, r *http.Request) {
	fmt.Println(r.Method, r.URL.Path)
	m, error := message_to_json(&message{Msg: "server_one"})
	if error != nil {
		w.WriteHeader(http.StatusInternalServerError)
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(m)
}

func main() {
	http.HandleFunc("/server_one", server_one)
	http.ListenAndServe(":8081", nil)
}
