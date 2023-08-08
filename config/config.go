package config

import (
	"log"

	"github.com/go-playground/validator/v10"
	"github.com/spf13/viper"
)

type Config struct {
	Port string `mapstructure:"PORT" validate:"required"`
}

func InitConfig() {
	viper.SetConfigName("application")
	viper.AddConfigPath(".")
	viper.AddConfigPath("/etc/API_NAME")
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
