require 'capybara/rspec'
require 'selenium-webdriver'

# Register selenium_remote_chrome driver for containerized testing
Capybara.register_driver :selenium_remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  
  # Configure Chrome options for headless mode
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1920,1080')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV['SELENIUM_REMOTE_URL'] || 'http://selenium:4444/wd/hub',
    options: options
  )
end

# Configure Capybara for container networking
Capybara.configure do |config|
  config.default_driver = :rack_test
  config.javascript_driver = :selenium_remote_chrome
  
  # Configure default wait times and retry behavior
  config.default_max_wait_time = 10
  
  # Configure server for container networking
  config.server = :webrick
  config.server_host = '0.0.0.0'
  config.server_port = 3000
  
  # Set app_host for remote Selenium to connect back to the Rails app
  # In container environment, use the container hostname
  config.app_host = "http://#{Socket.gethostname}:3000"
end

# Configure RSpec to use the remote driver for system tests
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_remote_chrome
  end
  
  # Save screenshots on test failure
  config.after(:each, type: :system) do |example|
    if example.exception
      meta = example.metadata
      filename = File.basename(meta[:file_path])
      line_number = meta[:line_number]
      screenshot_name = "screenshot-#{filename}-#{line_number}.png"
      screenshot_path = Rails.root.join('tmp', 'test_results', screenshot_name)
      
      # Ensure the test results directory exists
      FileUtils.mkdir_p(Rails.root.join('tmp', 'test_results'))
      
      # Save screenshot
      page.save_screenshot(screenshot_path)
      puts "\n[Screenshot] Saved to #{screenshot_path}"
    end
  end
end
