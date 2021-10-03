require "application_system_test_case"

class NormalsTest < ApplicationSystemTestCase
  test "saves daily attendances and rests" do
    freeze_time
    visit root_url

    # click
    assert_match
    [1, 2, 3].find do |i|
      i.to_s
    end
  end
end
