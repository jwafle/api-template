package config

import (
	"fmt"
	"log"
	"log/slog"
	"strings"

	"github.com/go-playground/validator/v10"
	"github.com/spf13/viper"
)

type Config struct {
	Port     string `mapstructure:"PORT" validate:"required"`
	LogLevel string `mapstructure:"LOG_LEVEL" validate:"required"`
}

func InitConfig() {
	viper.SetConfigName("application")
	viper.AddConfigPath(".")
	viper.AddConfigPath("/etc/api_repo_name")
	viper.SetEnvPrefix("API_ENV_PREFIX")
	viper.AutomaticEnv()
}

func ExtractConfig() Config {
	var cfg Config

	InitConfig()

	err := viper.ReadInConfig()

	if err != nil {
		log.Fatal("error reading in config")
	}

	err = viper.Unmarshal(&cfg)

	if err != nil {
		log.Fatal("error unmarshalling config")
	}

	ValidateConfig(cfg)

	return cfg
}

func ValidateConfig(cfg Config) {
	validate := validator.New()

	err := validate.Struct(cfg)
	if err != nil {
		log.Fatal("error validating config")
	}
}

func (c Config) ParseLevel() (slog.Level, error) {
	switch strings.ToUpper(c.LogLevel) {
	case "DEBUG":
		return slog.LevelDebug, nil
	case "INFO":
		return slog.LevelInfo, nil
	case "WARN":
		return slog.LevelWarn, nil
	case "ERROR":
		return slog.LevelError, nil
	default:
		return slog.LevelInfo, fmt.Errorf("unknown log level %q", c.LogLevel)
	}
}
