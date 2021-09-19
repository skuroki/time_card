require "application_system_test_case"

class NormalsTest < ApplicationSystemTestCase
  test "saves daily attendances and rests" do
    visit root_url

    assert_selector "h1", text: "Attendances"
  end
end
