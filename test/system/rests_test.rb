require "application_system_test_case"

class RestsTest < ApplicationSystemTestCase
  setup do
    @rest = rests(:one)
  end

  test "visiting the index" do
    visit rests_url
    assert_selector "h1", text: "Rests"
  end

  test "creating a Rest" do
    visit rests_url
    click_on "New Rest"

    fill_in "Attendance", with: @rest.attendance_id
    fill_in "Started at", with: @rest.started_at
    click_on "Create Rest"

    assert_text "Rest was successfully created"
    click_on "Back"
  end

  test "updating a Rest" do
    visit rests_url
    click_on "Edit", match: :first

    fill_in "Attendance", with: @rest.attendance_id
    fill_in "Started at", with: @rest.started_at
    click_on "Update Rest"

    assert_text "Rest was successfully updated"
    click_on "Back"
  end

  test "destroying a Rest" do
    visit rests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Rest was successfully destroyed"
  end
end
