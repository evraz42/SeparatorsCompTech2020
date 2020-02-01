package main

type Config struct {
	DBName    string `yaml:"db_name"`
	DBUser    string `yaml:"db_user"`
	DBHost    string `yaml:"db_host"`
	DBPort    int    `yaml:"db_port"`
	DBPass    string `yaml:"db_pass"`
	WSAddress string `yaml:"ws_address"`
}
