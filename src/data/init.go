package data

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

var DB *pgxpool.Pool

func InitDB() error {
	// Connection string - adapt to your docker-compose credentials
	dsn := "postgres://judge_user:your_secure_password@localhost:5432/judge_platform"
	
	config, err := pgxpool.ParseConfig(dsn)
	if err != nil {
		return fmt.Errorf("unable to parse DSN: %w", err)
	}

	// Initialize the connection pool
	pool, err := pgxpool.NewWithConfig(context.Background(), config)
	if err != nil {
		return fmt.Errorf("unable to connect to database: %w", err)
	}

	DB = pool
	return nil
}