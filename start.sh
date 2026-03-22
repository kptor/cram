#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Ensure Docker daemon is running
if ! docker info > /dev/null 2>&1; then
  echo "Docker is not running. Starting Docker Desktop..."
  open -a Docker
  echo "Waiting for Docker to start..."
  until docker info > /dev/null 2>&1; do
    sleep 2
  done
  echo "Docker is ready."
fi

echo "Building containers..."
docker compose build

echo "Starting Postgres and Redis..."
docker compose up -d db redis

echo "Waiting for Postgres to be ready..."
until docker compose exec db pg_isready -U postgres > /dev/null 2>&1; do
  sleep 1
done

echo "Running database migrations..."
docker compose run --rm api bundle exec rails db:create db:migrate 2>/dev/null || \
  docker compose run --rm api bundle exec rails db:migrate

echo "Starting all services in background..."
docker compose up -d

echo ""
echo "Waiting for services to be ready..."
until curl -sf http://localhost:4000/up > /dev/null 2>&1; do
  sleep 1
done

echo ""
echo "======================================"
echo "  cram is ready!"
echo "======================================"
echo ""
echo "  Frontend:   http://localhost:5173"
echo "  API:        http://localhost:4000"
echo "  GraphQL:    http://localhost:4000/graphql"
echo "  Sidekiq UI: http://localhost:4000/sidekiq"
echo "  Postgres:   localhost:5432"
echo "  Redis:      localhost:6379"
echo ""
echo "  Logs:       docker compose logs -f"
echo "  Stop:       docker compose down"
echo "======================================"

docker compose logs -f
