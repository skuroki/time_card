# Attendance Tracking Application

A Rails-based attendance tracking system with comprehensive E2E testing in Docker containers.

## Table of Contents

- [Requirements](#requirements)
- [Setup](#setup)
- [Running Tests](#running-tests)
- [Test Execution Methods](#test-execution-methods)
- [Environment Variables](#environment-variables)
- [Common Test Scenarios](#common-test-scenarios)
- [Troubleshooting](#troubleshooting)
- [Development](#development)

## Requirements

- Ruby 3.3.1
- Docker and Docker Compose
- PostgreSQL (for local development)
- Node.js (for asset compilation)

## Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Set up the database:
   ```bash
   rails db:create db:migrate
   ```
4. Create test environment file:
   ```bash
   cp .env.development .env.test
   ```

## Running Tests

### Quick Start

Run all tests in Docker containers:
```bash
bin/test
```

This command will:
- Start all required services (app, database)
- Run the complete test suite with Playwright driver
- Clean up containers after completion
- Display results with color-coded output

### Test Execution Methods

The application provides three different methods for running tests, each suited for different scenarios:

#### 1. Standard Test Execution (`bin/test`)

**When to use:** Running the full test suite or specific test files in a clean, isolated environment.

**Features:**
- Runs tests in Docker containers
- Automatic cleanup after execution
- Supports passing RSpec arguments
- Coverage reporting

**Examples:**
```bash
# Run all tests
bin/test

# Run specific test file
bin/test spec/system/attendance_workflow_spec.rb

# Run with coverage
bin/test --coverage

# Run specific test by line number
bin/test spec/system/attendance_workflow_spec.rb:15

# Run tests matching a pattern
bin/test --pattern "*attendance*"
```

#### 2. Watch Mode (`bin/test-watch`)

**When to use:** Active development where you want tests to automatically re-run when files change.

**Features:**
- Automatically re-runs tests on file changes (if guard-rspec is installed)
- Provides immediate feedback during development
- Keeps containers running between test runs

**Examples:**
```bash
# Start watch mode
bin/test-watch
```

**Note:** Requires `guard-rspec` gem. Add to your Gemfile:
```ruby
gem 'guard-rspec', require: false, group: :development
```

#### 3. Debug Mode (`bin/test-debug`)

**When to use:** Debugging failing tests or investigating test behavior with breakpoints.

**Features:**
- Interactive debugging with `binding.pry`
- Can open an interactive shell in the test container
- Allows manual test execution and inspection

**Examples:**
```bash
# Run specific test in debug mode
bin/test-debug spec/system/attendance_workflow_spec.rb

# Open interactive shell
bin/test-debug --shell

# Inside the shell, you can:
bundle exec rspec spec/system/attendance_workflow_spec.rb
rails console
```

**Using breakpoints:**
1. Add `binding.pry` in your test code
2. Run the test with `bin/test-debug`
3. The debugger will pause at the breakpoint
4. Inspect variables, step through code, etc.
5. Type `continue` to resume or `exit` to quit

### Direct Docker Compose Commands

For advanced usage, you can use docker-compose directly:

```bash
# Run all tests
docker-compose -f docker-compose.test.yml run --rm test

# Run specific test file
docker-compose -f docker-compose.test.yml run --rm test bundle exec rspec spec/system/attendance_workflow_spec.rb

# Run with environment variable
docker-compose -f docker-compose.test.yml run --rm -e COVERAGE=true test

# Start services without running tests
docker-compose -f docker-compose.test.yml up -d

# Stop all services
docker-compose -f docker-compose.test.yml down

# Clean up volumes
docker-compose -f docker-compose.test.yml down -v
```

## Environment Variables

### Required Variables

- `TIME_CARD_PASSWORD`: Password for HTTP Basic Authentication (required for system tests)

### Optional Variables

- `RAILS_ENV`: Rails environment (default: `test`)
- `DATABASE_URL`: PostgreSQL connection string (auto-configured in containers)
- `PLAYWRIGHT_BROWSERS_PATH`: Playwright browser cache directory (auto-configured in containers)
- `COVERAGE`: Enable coverage reporting (set to `true`)

### Configuration Files

- `.env.test`: Test environment variables (create from `.env.development`)
- `docker-compose.test.yml`: Docker Compose configuration for test environment

## Common Test Scenarios

### Running System Tests

System tests use Capybara with Playwright driver to test the application through a real browser:

```bash
# Run all system tests
bin/test spec/system/

# Run attendance workflow tests
bin/test spec/system/attendance_workflow_spec.rb

# Run authentication tests
bin/test spec/system/authentication_spec.rb

# Run report page tests
bin/test spec/system/report_page_spec.rb
```

**Note:** The application uses Playwright driver for browser automation, which provides better performance and reliability compared to Selenium. All existing Capybara test syntax remains unchanged.

### Running Integration Tests

Integration tests verify container setup and configuration:

```bash
# Run all integration tests
bin/test spec/integration/

# Run database idempotence tests
bin/test spec/integration/database_idempotence_spec.rb

# Run transactional rollback tests
bin/test spec/integration/transactional_rollback_spec.rb
```

### Running Unit Tests

Unit tests for models and controllers:

```bash
# Run all model tests
bin/test spec/models/

# Run specific model test
bin/test spec/models/attendance_spec.rb

# Run controller tests
bin/test spec/controllers/
```

### Viewing Test Results

Test artifacts are saved to `tmp/test_results/`:
- Screenshots from failed tests
- Test logs
- Coverage reports (when enabled)

```bash
# View screenshots from failed tests
ls -la tmp/test_results/*.png

# View test logs
cat tmp/test_results/test.log
```

## Troubleshooting

### Common Issues

#### 1. Docker Compose Not Found

**Error:** `docker-compose: command not found`

**Solution:** Install Docker Compose:
```bash
# macOS with Homebrew
brew install docker-compose

# Linux
sudo apt-get install docker-compose
```

#### 2. Database Connection Errors

**Error:** `could not connect to server: Connection refused`

**Solution:** Ensure PostgreSQL container is healthy:
```bash
# Check container status
docker-compose -f docker-compose.test.yml ps

# View database logs
docker-compose -f docker-compose.test.yml logs db

# Restart services
docker-compose -f docker-compose.test.yml down
docker-compose -f docker-compose.test.yml up -d
```

#### 3. Playwright Browser Issues

**Error:** `Browser not found` or `Playwright executable not found`

**Solution:** Rebuild Docker image to install Playwright browsers:
```bash
# Rebuild test container
docker-compose -f docker-compose.test.yml build test

# Or rebuild without cache
docker-compose -f docker-compose.test.yml build --no-cache test
```

#### 4. Port Already in Use

**Error:** `port is already allocated`

**Solution:** Stop conflicting services:
```bash
# Find process using port 3000 (Rails test server)
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or use different ports in docker-compose.test.yml
```

#### 5. Permission Denied Errors

**Error:** `Permission denied` when running scripts

**Solution:** Make scripts executable:
```bash
chmod +x bin/test bin/test-watch bin/test-debug
```

#### 6. Missing Environment Variables

**Error:** `TIME_CARD_PASSWORD is not set`

**Solution:** Create `.env.test` file:
```bash
cp .env.development .env.test
# Edit .env.test and set TIME_CARD_PASSWORD
```

#### 7. Stale Containers or Volumes

**Error:** Tests fail with unexpected data or state

**Solution:** Clean up Docker resources:
```bash
# Stop and remove containers
docker-compose -f docker-compose.test.yml down

# Remove volumes (WARNING: deletes all test data)
docker-compose -f docker-compose.test.yml down -v

# Remove all unused Docker resources
docker system prune -f
```

#### 8. Slow Test Execution

**Issue:** Tests take longer than expected

**Solutions:**
- Run tests in parallel (requires parallel_tests gem)
- Reduce Capybara wait times for faster feedback
- Use `--fail-fast` to stop on first failure
- Run only affected tests during development

```bash
# Run with fail-fast
bin/test --fail-fast

# Run specific test file instead of full suite
bin/test spec/system/attendance_workflow_spec.rb
```

#### 9. Screenshot Not Captured

**Issue:** Failed test doesn't have a screenshot

**Solution:** Check screenshot directory and permissions:
```bash
# Create directory if missing
mkdir -p tmp/test_results

# Check permissions
ls -la tmp/test_results/

# View Capybara configuration
cat spec/support/capybara.rb
```

#### 10. Tests Pass Locally But Fail in CI

**Issue:** Tests work on your machine but fail in CI

**Solutions:**
- Check environment variables in CI configuration
- Verify Docker and docker-compose versions match
- Review CI logs for specific error messages
- Ensure `.env.test` is properly configured in CI
- Check for timing issues (increase wait times)

### Getting Help

If you encounter issues not covered here:

1. Check the test output for specific error messages
2. Review logs in `tmp/test_results/`
3. Check Docker container logs: `docker-compose -f docker-compose.test.yml logs`
4. Verify all environment variables are set correctly
5. Try cleaning up and restarting: `docker-compose -f docker-compose.test.yml down -v`

## Development

### Adding New Tests

1. Create test file in appropriate directory:
   - `spec/system/` for E2E tests
   - `spec/integration/` for integration tests
   - `spec/models/` for model tests
   - `spec/controllers/` for controller tests

2. Use FactoryBot for test data:
   ```ruby
   let(:attendance) { create(:attendance) }
   ```

3. For system tests, use authentication helper:
   ```ruby
   before do
     sign_in_with_basic_auth
   end
   ```

4. Run your new test:
   ```bash
   bin/test spec/system/your_new_test_spec.rb
   ```

### Test Structure

```
spec/
├── system/           # E2E tests with Capybara
├── integration/      # Container and integration tests
├── models/           # Model unit tests
├── controllers/      # Controller tests
├── factories/        # FactoryBot factories
└── support/          # Test helpers and configuration
```

### Continuous Integration

Tests run automatically in GitHub Actions on every push and pull request. See `.github/workflows/deploy.yml` for CI configuration.

CI workflow:
1. Checkout code
2. Set up Docker Buildx
3. Run tests with docker-compose
4. Upload test artifacts (screenshots, logs) on failure
5. Deploy (if tests pass)

## License

[Your License Here]
