package config

import "github.com/spf13/viper"

type Config struct {
	Port      string `mapstructure:"PORT"`
	DBUrl     string `mapstructure:"DB_URL"`
	SchoolUrl string `mapstructure:"SCHOOL_URL"`
}

func LoadConfig() (config Config, err error) {
	viper.AddConfigPath("../lessons/pkg/config")
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
