# System test helper module for E2E tests
# Provides authentication and wait helpers for Capybara system tests
module SystemTestHelper
  # Sign in using HTTP Basic Authentication
  # For Playwright driver, include credentials in the URL
  def sign_in_with_basic_auth
    @basic_auth_username = 'skuroki'
    @basic_auth_password = ENV['TIME_CARD_PASSWORD'] || 'test_password'
  end
  
  # Override visit to include basic auth credentials in the URL
  def visit(path)
    if @basic_auth_username && @basic_auth_password
      # For relative paths, construct full URL with credentials
      if path.start_with?('/')
        host = Capybara.current_session.server.host
        port = Capybara.current_session.server.port
        authenticated_url = "http://#{@basic_auth_username}:#{@basic_auth_password}@#{host}:#{port}#{path}"
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
  # Turbo shows a progress bar during navigation (Turbo Drive)
  # For Turbo Frames, we wait for the frame to finish loading
  def wait_for_turbo(frame_id: nil)
    if frame_id
      # Wait for specific Turbo Frame to finish loading
      # Turbo adds [busy] attribute during frame updates
      expect(page).to have_no_css("turbo-frame##{frame_id}[busy]", wait: Capybara.default_max_wait_time)
    else
      # Wait for the turbo progress bar to disappear (Turbo Drive navigation)
      expect(page).to have_no_css('.turbo-progress-bar', wait: Capybara.default_max_wait_time)
    end
  rescue Capybara::ElementNotFound
    # Progress bar or busy state might not appear for fast requests, which is fine
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
