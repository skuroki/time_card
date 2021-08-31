require "application_system_test_case"

class ClockOutsTest < ApplicationSystemTestCase
  setup do
    @clock_out = clock_outs(:one)
  end

  test "visiting the index" do
    visit clock_outs_url
    assert_selector "h1", text: "Clock Outs"
  end

  test "creating a Clock out" do
    visit clock_outs_url
    click_on "New Clock Out"

    fill_in "Attendance", with: @clock_out.attendance_id
    fill_in "Finished at", with: @clock_out.finished_at
    click_on "Create Clock out"

    assert_text "Clock out was successfully created"
    click_on "Back"
  end

  test "updating a Clock out" do
    visit clock_outs_url
    click_on "Edit", match: :first

    fill_in "Attendance", with: @clock_out.attendance_id
    fill_in "Finished at", with: @clock_out.finished_at
    click_on "Update Clock out"

    assert_text "Clock out was successfully updated"
    click_on "Back"
  end

  test "destroying a Clock out" do
    visit clock_outs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Clock out was successfully destroyed"
  end
end
