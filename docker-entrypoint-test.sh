#!/bin/bash
set -e

# Function to check database readiness
check_database() {
  PGPASSWORD=test_password psql -h db -U postgres -d attendance_test -c '\q' 2>/dev/null
}

# Wait for database with retry logic
echo "Waiting for database to be ready..."
MAX_RETRIES=30
RETRY_COUNT=0

until check_database; do
  RETRY_COUNT=$((RETRY_COUNT + 1))
  
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "Error: Database is not available after $MAX_RETRIES attempts"
    echo "Connection details: host=db, user=postgres, database=attendance_test"
    exit 1
  fi
  
  echo "Database is unavailable - attempt $RETRY_COUNT/$MAX_RETRIES - sleeping"
  sleep 1
done

echo "Database is up - setting up test database"

# Install gems if needed
bundle check || bundle install

# Run database migrations and test preparation
bundle exec rails db:test:prepare

# Create test results directory
mkdir -p tmp/test_results

echo "Test environment is ready"

# Execute the main command with proper error handling
exec "$@"
