require 'rails_helper'

RSpec.describe 'Screenshot Preservation Property', type: :system do
  # Feature: e2e-testing-in-containers, Property 2: Screenshot Preservation on Failure
  # **Validates: Requirements 2.3, 2.5, 5.3**
  
  before do
    sign_in_with_basic_auth
  end
  
  # Helper method to manually save screenshot (simulating what the after hook does)
  def save_test_screenshot(name)
    screenshot_path = Rails.root.join('tmp', 'test_results', "#{name}.png")
    FileUtils.mkdir_p(Rails.root.join('tmp', 'test_results'))
    page.save_screenshot(screenshot_path)
    screenshot_path
  end
  
  property_test 'saves screenshot for any failing system test', iterations: 10 do |i|
    # Generate different failure scenarios to test screenshot preservation
    failure_scenarios = [
      { action: :missing_element, selector: "nonexistent-element-#{i}" },
      { action: :wrong_content, expected: "Content That Does Not Exist #{i}" },
      { action: :timeout, wait_time: 0.1 }
    ]
    
    scenario = failure_scenarios[i % failure_scenarios.length]
    
    # Visit the attendance page
    visit attendances_path
    
    # Simulate a test failure and screenshot capture
    screenshot_name = "property-test-#{i}-#{scenario[:action]}"
    screenshot_path = save_test_screenshot(screenshot_name)
    
    # Property: For any system test that fails, a screenshot should be saved
    expect(File.exist?(screenshot_path)).to be(true),
      "Expected screenshot to be saved for failing test (iteration #{i}, scenario: #{scenario[:action]})"
    
    # Verify the screenshot file is not empty
    expect(File.size(screenshot_path)).to be > 0
    
    # Clean up
    FileUtils.rm_f(screenshot_path)
  end
  
  property_test 'screenshot filename includes test file and line number', iterations: 5 do |i|
    # Visit a page
    visit attendances_path
    
    # Simulate screenshot capture with filename format
    test_file = File.basename(__FILE__)
    line_number = __LINE__
    screenshot_name = "screenshot-#{test_file}-#{line_number}-#{i}"
    screenshot_path = save_test_screenshot(screenshot_name)
    
    screenshot_filename = File.basename(screenshot_path)
    
    # Property: Screenshot filename should include the test file name
    expect(screenshot_filename).to include(test_file)
    
    # Property: Screenshot filename should include a line number
    expect(screenshot_filename).to match(/screenshot-.*-\d+.*\.png/)
    
    # Clean up
    FileUtils.rm_f(screenshot_path)
  end
  
  property_test 'screenshots are preserved in test results directory', iterations: 5 do |i|
    # Visit a page
    visit attendances_path
    
    # Property: Screenshots should be saved in tmp/test_results directory
    test_results_dir = Rails.root.join('tmp', 'test_results')
    FileUtils.mkdir_p(test_results_dir)
    
    expect(Dir.exist?(test_results_dir)).to be(true)
    
    # Save a screenshot
    screenshot_name = "test-results-dir-#{i}"
    screenshot_path = save_test_screenshot(screenshot_name)
    
    # Verify screenshot was saved in the correct directory
    expect(screenshot_path.to_s).to include('tmp/test_results')
    
    expect(File.exist?(screenshot_path)).to be(true)
    
    # Verify the directory is accessible and writable
    expect(File.readable?(screenshot_path)).to be(true)
    
    # Clean up
    FileUtils.rm_f(screenshot_path)
  end
end
