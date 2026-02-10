# Implementation Plan: E2E Testing in Containers

## Overview

This implementation plan breaks down the E2E testing infrastructure into discrete, incremental tasks. Each task builds on previous work, starting with basic container setup and progressing to full system test implementation with property-based testing.

**Completed Infrastructure:**
- Docker Compose test environment (tasks 1-3) ✓
- Test-specific Dockerfile and entrypoint ✓
- Capybara configuration for remote Selenium ✓
- Screenshot capture on test failure ✓
- Property testing helper module ✓

**Remaining Work:**
- Database management and cleanup configuration
- System test helpers and FactoryBot factories
- Actual system tests for attendance workflows
- Error handling and retry logic
- CI/CD integration updates
- Helper scripts and documentation
- Property-based tests for correctness properties

## Tasks

- [x] 1. Create Docker Compose test environment configuration
  - Create `docker-compose.test.yml` with services for test runner, PostgreSQL, and Selenium
  - Configure service dependencies and health checks
  - Set up volume mounts for code, test results, and bundle cache
  - Configure environment variables for test execution
  - _Requirements: 1.1, 1.3, 3.1, 3.2, 3.3, 3.5_

- [x] 2. Create test-specific Dockerfile and entrypoint
  - [x] 2.1 Create `Dockerfile.test` for test runner container
    - Base on Ruby 3.3.1 slim image
    - Install system dependencies (PostgreSQL client, Node.js, build tools)
    - Copy and install gems from Gemfile
    - Precompile test assets
    - _Requirements: 1.1, 1.2_

  - [x] 2.2 Create `docker-entrypoint-test.sh` script
    - Implement database readiness check with retry logic
    - Run database migrations and test preparation
    - Create test results directory
    - Execute main command with proper error handling
    - _Requirements: 1.3, 3.3_

  - [x] 2.3 Write integration test for container startup
    - **Property 1: Container Exit Status Reflects Test Results**
    - **Validates: Requirements 1.4**

- [x] 3. Configure Capybara for remote Selenium
  - [x] 3.1 Create `spec/support/capybara.rb` configuration
    - Register selenium_remote_chrome driver
    - Configure Chrome options for headless mode
    - Set up Capybara server host and port for container networking
    - Configure default wait times and retry behavior
    - _Requirements: 2.1, 2.2, 7.3_

  - [x] 3.2 Add screenshot capture on test failure
    - Implement after hook to save screenshots for failed system tests
    - Configure screenshot path to test results directory
    - Add logging for screenshot locations
    - _Requirements: 2.3, 2.5_

  - [x] 3.3 Write property test for screenshot preservation
    - **Property 2: Screenshot and Log Preservation on Failure**
    - **Validates: Requirements 2.3, 2.5, 5.3**

- [-] 4. Set up test database management
  - [x] 4.1 Add database_cleaner gem to Gemfile
    - Add `database_cleaner-active_record` to test group in Gemfile
    - Run `bundle install` to install the gem
    - _Requirements: 4.1, 4.2_

  - [x] 4.2 Configure database_cleaner for system tests
    - Create `spec/support/database_cleaner.rb` configuration
    - Set truncation strategy for system tests
    - Configure transaction strategy for unit tests
    - _Requirements: 4.1, 4.2_

  - [x] 4.3 Update rails_helper.rb for container environment
    - Disable transactional fixtures for system tests
    - Configure database_cleaner hooks (before/after each)
    - Keep transactional fixtures enabled for non-system tests
    - _Requirements: 4.1, 4.2_

  - [x]* 4.4 Write property test for database idempotence
    - **Property 4: Test Database Idempotence**
    - **Validates: Requirements 4.1, 4.4**

  - [x]* 4.5 Write property test for transactional rollback
    - **Property 5: Transactional Rollback**
    - **Validates: Requirements 4.2**

- [-] 5. Create system test helpers and utilities
  - [x] 5.1 Create `spec/support/system_test_helper.rb`
    - Implement sign_in_with_basic_auth helper
    - Add wait_for_ajax helper for JavaScript interactions
    - Add wait_for_turbo helper for Turbo frame loading
    - Include helper module in system test configuration
    - _Requirements: 6.2, 6.5_

  - [ ]* 5.2 Write unit tests for system test helpers
    - Test basic auth helper functionality
    - Test wait helpers with mock scenarios
    - _Requirements: 6.2, 6.5_

- [x] 6. Checkpoint - Verify infrastructure setup
  - Ensure all configuration files are created
  - Run docker-compose build to verify Dockerfile
  - Test database connection and migration
  - Test Selenium connection
  - Ask the user if questions arise

- [x] 7. Create FactoryBot factories for test data
  - [x] 7.1 Add FactoryBot gem to Gemfile
    - Add `factory_bot_rails` to test group in Gemfile
    - Run `bundle install` to install the gem
    - _Requirements: 6.3_

  - [x] 7.2 Configure FactoryBot in rails_helper.rb
    - Add FactoryBot configuration to RSpec
    - Include FactoryBot syntax methods
    - _Requirements: 6.3_

  - [x] 7.3 Create `spec/factories/attendances.rb`
    - Define base attendance factory
    - Add trait for attendance with clock_out
    - Add trait for attendance with rest periods
    - _Requirements: 6.3_

  - [x] 7.4 Create factories for related models
    - Create `spec/factories/clock_outs.rb`
    - Create `spec/factories/rests.rb`
    - Create `spec/factories/rest_finishes.rb`
    - _Requirements: 6.3_

  - [ ]* 7.5 Write unit tests for factories
    - Test factory creation and associations
    - Test factory traits
    - _Requirements: 6.3_

- [x] 8. Implement attendance workflow system tests
  - [x] 8.1 Create spec/system directory
    - Create the directory structure for system tests
    - _Requirements: 6.1_

  - [x] 8.2 Create `spec/system/attendance_workflow_spec.rb`
    - Write test for complete clock-in to clock-out workflow
    - Test rest period start and end
    - Verify UI updates after each action
    - Test error handling for invalid operations
    - _Requirements: 6.3_

  - [ ]* 8.3 Write property test for parallel test isolation
    - **Property 3: Parallel Test Isolation**
    - **Validates: Requirements 2.4**

- [x] 9. Implement report page system tests
  - [x] 9.1 Create `spec/system/report_page_spec.rb`
    - Write test for displaying current month attendances
    - Test month filtering functionality
    - Verify working hours calculation
    - Test data sorting and formatting
    - _Requirements: 6.4_

  - [ ]* 9.2 Write unit tests for report calculations
    - Test working hours calculation
    - Test rest time calculation
    - Test edge cases (overnight shifts, etc.)
    - _Requirements: 6.4_

- [x] 10. Implement authentication system tests
  - [x] 10.1 Create `spec/system/authentication_spec.rb`
    - Write test for successful authentication
    - Test authentication failure scenarios
    - Verify protected pages require authentication
    - _Requirements: 6.5_

  - [ ]* 10.2 Write unit tests for authentication helpers
    - Test basic auth encoding
    - Test authentication header handling
    - _Requirements: 6.5_

- [ ]* 11. Add error handling and retry logic
  - [ ]* 11.1 Implement network retry logic in Capybara configuration
    - Add retry wrapper for Selenium commands
    - Configure exponential backoff
    - Set maximum retry attempts
    - _Requirements: 7.2_

  - [ ]* 11.2 Add timeout error diagnostics
    - Enhance error messages with state information
    - Capture page HTML on timeout
    - Log pending operations
    - _Requirements: 7.5, 8.5_

  - [ ]* 11.3 Write property test for network retry behavior
    - **Property 7: Network Operation Retry**
    - **Validates: Requirements 7.2**

  - [ ]* 11.4 Write property test for timeout diagnostics
    - **Property 8: Timeout Diagnostic Information**
    - **Validates: Requirements 7.5**

- [x] 12. Checkpoint - Verify all tests pass
  - Run full test suite in containers
  - Verify all property tests pass
  - Check test execution time meets performance targets
  - Ensure all tests pass, ask the user if questions arise

- [-] 13. Add CI/CD integration configuration
  - [x] 13.1 Update GitHub Actions workflow file
    - Update `.github/workflows/deploy.yml` to use docker-compose for tests
    - Configure Docker Buildx setup
    - Add test execution step with docker-compose
    - Configure artifact upload for test results
    - Keep existing deployment steps
    - _Requirements: 5.1, 5.2, 5.3_

  - [ ]* 13.2 Write integration test for CI execution
    - Test that CI workflow runs successfully
    - Verify artifact preservation
    - _Requirements: 5.1, 5.2, 5.3_

- [x] 14. Create helper scripts and documentation
  - [x] 14.1 Create test execution scripts
    - Create `bin/test` script for running all tests in containers
    - Create `bin/test-watch` script for watch mode
    - Create `bin/test-debug` script for debugging with interactive mode
    - Make scripts executable
    - _Requirements: 8.1, 8.2, 8.3_

  - [x] 14.2 Create or update README documentation
    - Document test execution commands
    - Add troubleshooting section
    - Document environment variables
    - Add examples of common test scenarios
    - Explain when to use different test execution methods
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_

  - [ ]* 14.3 Write unit tests for helper scripts
    - Test script argument parsing
    - Test error handling in scripts
    - _Requirements: 8.1_

- [ ]* 15. Add property tests for remaining properties
  - [ ]* 15.1 Write property test for temporary file cleanup
    - **Property 6: Temporary File Cleanup**
    - **Validates: Requirements 4.3**

  - [ ]* 15.2 Write property test for test failure error messages
    - **Property 9: Test Failure Error Messages**
    - **Validates: Requirements 8.5**

- [x] 16. Final checkpoint - Complete system verification
  - Run full test suite including all property tests
  - Verify all 9 correctness properties pass
  - Test CI integration end-to-end
  - Verify documentation is complete and accurate
  - Measure and verify performance targets
  - Ensure all tests pass, ask the user if questions arise

## Notes

- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties
- Unit tests validate specific examples and edge cases
- The implementation follows a bottom-up approach: infrastructure → configuration → helpers → tests
- All property tests should run with minimum 100 iterations
- System tests should use realistic test data from factories
