# Simple Makefile for a Go project

# Build the application
all: build test

build:
	@echo "Building..."
	
	
	@go build -o main cmd/api/main.go

# Run the application
run:
	@go run cmd/api/main.go
# Create DB container
docker-run:
	@if docker compose up --build 2>/dev/null; then \
		: ; \
	else \
		echo "Falling back to Docker Compose V1"; \
		docker-compose up --build; \
	fi

# Shutdown DB container
docker-down:
	@if docker compose down 2>/dev/null; then \
		: ; \
	else \
		echo "Falling back to Docker Compose V1"; \
		docker-compose down; \
	fi

# Test the application
test:
	@echo "Testing..."
	@go test ./... -v
# Integrations Tests for the application
itest:
	@echo "Running integration tests..."
	@go test ./internal/database -v

# Clean the binary
clean:
	@echo "Cleaning..."
	@rm -f main

# Live Reload
watch:
	@if command -v air > /dev/null; then \
            air; \
            echo "Watching...";\
        else \
            read -p "Go's 'air' is not installed on your machine. Do you want to install it? [Y/n] " choice; \
            if [ "$$choice" != "n" ] && [ "$$choice" != "N" ]; then \
                go install github.com/air-verse/air@latest; \
                air; \
                echo "Watching...";\
            else \
                echo "You chose not to install air. Exiting..."; \
                exit 1; \
            fi; \
        fi

GOOSE_DRIVER=postgres
GOOSE_DBSTRING=postgres://xzam:password@localhost:5434/xzam?sslmode=disable
MIGRATION_DIR=internal/database/migrations
# Migrate
migrate-create:
	@goose -dir $(MIGRATION_DIR) $(GOOSE_DRIVER) $(GOOSE_DBSTRING) create $(name) sql

migrate-up:
	@goose -dir $(MIGRATION_DIR) $(GOOSE_DRIVER) $(GOOSE_DBSTRING) up

migrate-down:
	@goose -dir $(MIGRATION_DIR) $(GOOSE_DRIVER) $(GOOSE_DBSTRING) down

.PHONY: all build run test clean watch docker-run docker-down itest migrate-create migrate-up migrate-down
