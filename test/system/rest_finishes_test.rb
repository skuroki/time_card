require "application_system_test_case"

class RestFinishesTest < ApplicationSystemTestCase
  setup do
    @rest_finish = rest_finishes(:one)
  end

  test "visiting the index" do
    visit rest_finishes_url
    assert_selector "h1", text: "Rest Finishes"
  end

  test "creating a Rest finish" do
    visit rest_finishes_url
    click_on "New Rest Finish"

    fill_in "Finished at", with: @rest_finish.finished_at
    fill_in "Rest", with: @rest_finish.rest_id
    click_on "Create Rest finish"

    assert_text "Rest finish was successfully created"
    click_on "Back"
  end

  test "updating a Rest finish" do
    visit rest_finishes_url
    click_on "Edit", match: :first

    fill_in "Finished at", with: @rest_finish.finished_at
    fill_in "Rest", with: @rest_finish.rest_id
    click_on "Update Rest finish"

    assert_text "Rest finish was successfully updated"
    click_on "Back"
  end

  test "destroying a Rest finish" do
    visit rest_finishes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Rest finish was successfully destroyed"
  end
end
