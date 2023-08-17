package api

import (
	"net/http"

	"github.com/go-chi/chi/v5"
)

func HealthRoute(r *chi.Mux) {
	r.Get("/health", healthHandler)
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Ok"))
}
