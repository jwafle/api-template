package main

import (
	"log/slog"
	"net/http"
	"os"

	api "github.com/jwafle/api-template/cmd"
	"github.com/jwafle/api-template/config"
)

func main() {
	cfg := config.ExtractConfig()

	var programLevel = new(slog.LevelVar)
	h := slog.NewJSONHandler(os.Stderr, &slog.HandlerOptions{Level: programLevel})
	slog.SetDefault(slog.New(h))

	level, err := cfg.ParseLevel()
	if err != nil {
		slog.Error("error parsing logging level, setting to default INFO", slog.String("error", err.Error()))
	}

	programLevel.Set(level)

	r := api.NewRouter(cfg)

	http.ListenAndServe(cfg.Port, r)
	slog.Info("server started")
}
