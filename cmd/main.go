package main

import (
	"fmt"
	"net/http"
	"strings"
)

func findAccessTokenCookie(cookies []*http.Cookie) string {
	for _, c := range cookies {
		if strings.HasPrefix(c.Name, "AccessToken-") {
			return c.Value
		}
	}
	return ""
}

func handler(w http.ResponseWriter, r *http.Request) {
	token := findAccessTokenCookie(r.Cookies())
	if token == "" {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	w.Header().Set("Authorization", "Bearer " + token)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	fmt.Fprint(w, "{}")
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("Listening on :9000")
	http.ListenAndServe(":9000", nil)
}