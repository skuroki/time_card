# System test helper module for E2E tests
# Provides authentication and wait helpers for Capybara system tests
module SystemTestHelper
  # Sign in using HTTP Basic Authentication
  # Uses the same credentials as the application controller
  # 
  # For Selenium WebDriver, HTTP Basic Auth is handled by including
  # credentials in the URL when visiting pages
  def sign_in_with_basic_auth
    @basic_auth_username = 'skuroki'
    @basic_auth_password = ENV['TIME_CARD_PASSWORD'] || 'test_password'
  end
  
  # Override visit to include basic auth credentials in the URL
  # This is the standard way to handle HTTP Basic Auth with Selenium
  def visit(path)
    if @basic_auth_username && @basic_auth_password
      # For relative paths, construct full URL with credentials
      if path.start_with?('/')
        # Use Capybara's app_host which is configured for container networking
        app_host = Capybara.app_host || "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}"
        uri = URI.parse(app_host)
        uri.user = @basic_auth_username
        uri.password = @basic_auth_password
        uri.path = path
        authenticated_url = uri.to_s
        super(authenticated_url)
      else
        # For absolute URLs, parse and add credentials
        uri = URI.parse(path)
        uri.user = @basic_auth_username
        uri.password = @basic_auth_password
        super(uri.to_s)
      end
    else
      super(path)
    end
  end

  # Wait for Turbo to finish loading
  # Turbo shows a progress bar during navigation
  def wait_for_turbo
    # Wait for the turbo progress bar to disappear
    expect(page).to have_no_css('.turbo-progress-bar', wait: Capybara.default_max_wait_time)
  rescue Capybara::ElementNotFound
    # Progress bar might not appear for fast requests, which is fine
  end

  # Wait for AJAX requests to complete
  # Note: This is for legacy jQuery-based AJAX, but included for compatibility
  # Modern Rails apps use Turbo instead
  def wait_for_ajax
    # Check if jQuery is available
    return unless page.evaluate_script('typeof jQuery !== "undefined"')
    
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until page.evaluate_script('jQuery.active').zero?
    end
  rescue Timeout::Error
    raise 'AJAX requests did not complete within the timeout period'
  rescue Selenium::WebDriver::Error::JavaScriptError
    # jQuery not available, skip waiting
  end
end

# Include the helper module in system tests
RSpec.configure do |config|
  config.include SystemTestHelper, type: :system
end
