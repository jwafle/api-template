package main

import (
	"net/http"

	api "github.com/jwafle/api-template/cmd"
	"github.com/jwafle/api-template/config"
)

func main() {
	cfg := config.ExtractConfig()

	r := api.NewRouter(cfg)

	http.ListenAndServe(cfg.Port, r)
}
