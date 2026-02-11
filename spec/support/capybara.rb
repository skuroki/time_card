require 'capybara/rspec'
require 'capybara/playwright'

# Register Playwright driver for Capybara
Capybara.register_driver :playwright do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: :chromium,
    headless: true,
    playwright_cli_executable_path: 'playwright',
    browser_options: {
      args: [
        '--no-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu'
      ]
    },
    screen: {
      width: 1920,
      height: 1080
    }
  )
end

# Configure Capybara to use Playwright driver
Capybara.default_driver = :playwright
Capybara.javascript_driver = :playwright

# Configure Capybara for container networking
Capybara.configure do |config|
  # Configure default wait times and retry behavior
  config.default_max_wait_time = 10
  
  # Configure server for container networking
  config.server = :webrick
  config.server_host = '0.0.0.0'
  config.server_port = 3000
  
  # Set app_host for Playwright to connect to the Rails app
  # In container environment, use the container hostname
  config.app_host = "http://#{Socket.gethostname}:3000"
end

# Configure RSpec to use Playwright driver for system tests
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :playwright
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
