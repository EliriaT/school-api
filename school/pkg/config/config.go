package config

import "github.com/spf13/viper"

type Config struct {
	Port        string `mapstructure:"PORT"`
	DBUrl       string `mapstructure:"DB_URL"`
	SecretKey   string `mapstructure:"TOKEN_SECRET_KEY"`
	SDUrl       string `mapstructure:"SD_URL"`
	ServiceType string `mapstructure:"SERVICE_TYPE"`
	MyUrl       string `mapstructure:"MY_URL"`
}

func LoadConfig() (config Config, err error) {
	viper.AddConfigPath("../school/pkg/config")
	viper.SetConfigName("app")
	viper.SetConfigType("env")

	viper.AutomaticEnv()

	err = viper.ReadInConfig()

	if err != nil {
		return
	}

	err = viper.Unmarshal(&config)

	return
}
