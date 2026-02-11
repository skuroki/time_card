# Implementation Plan: Playwright Driver Migration

## Overview

This implementation plan covers the migration from Selenium driver to Playwright driver for Capybara-based E2E testing. The existing containerized test infrastructure is already in place and working with Selenium. This migration only replaces the browser driver layer while maintaining all existing Capybara test code.

**Current State:**
- Docker Compose test environment with Selenium ✓
- Capybara-based system tests ✓
- Database management and cleanup ✓
- Test helpers and factories ✓
- CI/CD integration ✓

**Migration Goal:**
- Replace Selenium driver with Playwright driver
- Remove Selenium container dependency
- Maintain all existing test code (no rewrites)
- Improve performance and reduce resource usage

## Tasks

- [x] 1. Update Gemfile for Playwright driver
  - [x] 1.1 Remove Selenium gem
    - Remove `selenium-webdriver` from Gemfile
    - Keep `capybara` gem (no changes)
    - _Requirements: 2.1, 2.2_

  - [x] 1.2 Add Playwright driver gem for Capybara
    - Add `capybara-playwright-driver` to test group in Gemfile
    - Run `bundle install` to install the gem
    - _Requirements: 2.1, 2.2_

- [x] 2. Update Docker Compose configuration
  - [x] 2.1 Remove Selenium service from docker-compose.test.yml
    - Remove selenium service definition
    - Remove SELENIUM_REMOTE_URL environment variable from test service
    - Remove selenium dependency from test service
    - _Requirements: 3.2_

  - [x] 2.2 Add Playwright environment variables
    - Add PLAYWRIGHT_BROWSERS_PATH environment variable
    - Add playwright_cache volume for browser binaries
    - _Requirements: 2.1_

- [x] 3. Update Dockerfile.test for Playwright
  - [x] 3.1 Add Playwright system dependencies
    - Add Node.js and npm (if not already present)
    - Add Playwright browser dependencies (libnss3, libatk, libcups2, etc.)
    - _Requirements: 2.1, 2.2_

  - [x] 3.2 Install Playwright and browsers
    - Install Playwright CLI via npm
    - Run `playwright install chromium --with-deps`
    - _Requirements: 2.1, 2.2_

- [x] 4. Update Capybara configuration
  - [x] 4.1 Update `spec/support/capybara.rb` to use Playwright driver
    - Remove Selenium driver registration
    - Register :playwright driver using capybara-playwright-driver
    - Configure Chromium browser with headless mode
    - Set browser options (--no-sandbox, --disable-dev-shm-usage, --disable-gpu)
    - Configure screen size (1920x1080)
    - Set Capybara.default_driver and Capybara.javascript_driver to :playwright
    - Keep existing server host/port configuration
    - Keep existing screenshot configuration
    - _Requirements: 2.1, 2.2, 2.3, 2.5_

  - [x] 4.2 Write property test for screenshot preservation
    - **Property 2: Screenshot Preservation on Failure**
    - **Validates: Requirements 2.3, 2.5, 5.3**

- [x] 5. Update rails_helper.rb
  - [x] 5.1 Update driver configuration
    - Change `driven_by :selenium_remote_chrome` to `driven_by :playwright`
    - Ensure Capybara support file is required
    - _Requirements: 6.1_

- [x] 6. Review and update system test helpers
  - [x] 6.1 Review sign_in_with_basic_auth helper
    - Verify it works with Playwright driver
    - Update if necessary for Playwright compatibility
    - _Requirements: 6.5_

  - [x] 6.2 Review wait_for_turbo helper
    - Verify it works with Playwright driver
    - Should work as-is with Capybara API
    - _Requirements: 6.2_

- [x] 7. Verify existing system tests
  - [x] 7.1 Run spec/system/attendance_workflow_spec.rb
    - Verify test passes without code changes
    - Existing Capybara syntax should work as-is
    - _Requirements: 6.3_

  - [x] 7.2 Run spec/system/report_page_spec.rb
    - Verify test passes without code changes
    - Existing Capybara syntax should work as-is
    - _Requirements: 6.4_

  - [x] 7.3 Run spec/system/authentication_spec.rb
    - Verify test passes without code changes
    - Existing Capybara syntax should work as-is
    - _Requirements: 6.5_

- [x] 8. Checkpoint - Verify migration
  - Run full test suite with Playwright driver
  - Verify all system tests pass
  - Check screenshot capture on failures
  - Verify container startup and browser initialization
  - Ensure all tests pass, ask the user if questions arise

- [x] 9. Update documentation
  - [x] 9.1 Update README.md
    - Replace Selenium references with Playwright driver
    - Emphasize that Capybara syntax remains unchanged
    - Update troubleshooting section for Playwright-specific issues
    - _Requirements: 9.1, 9.2, 9.3_

  - [x] 9.2 Verify helper scripts
    - Verify bin/test script works with Playwright driver
    - Verify bin/test-watch script works with Playwright driver
    - Verify bin/test-debug works with Playwright driver
    - _Requirements: 8.1, 8.2, 8.3_

- [x] 10. Final verification
  - Run full test suite including all property tests
  - Verify performance improvements over Selenium
  - Test CI integration end-to-end
  - Measure and verify performance targets
  - Ensure all tests pass, ask the user if questions arise

## Notes

- Tasks marked with `*` are optional
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- **Key Principle**: Capybara is retained - only the driver changes from Selenium to Playwright
- **No Test Rewrites**: Existing test code using Capybara syntax remains unchanged
- **Performance Target**: Playwright driver should provide faster test execution and lower resource usage
