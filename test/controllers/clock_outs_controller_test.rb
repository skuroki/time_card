require "test_helper"

class ClockOutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @clock_out = clock_outs(:one)
  end

  test "should get index" do
    get clock_outs_url
    assert_response :success
  end

  test "should get new" do
    get new_clock_out_url
    assert_response :success
  end

  test "should create clock_out" do
    assert_difference('ClockOut.count') do
      post clock_outs_url, params: { clock_out: { attendance_id: @clock_out.attendance_id, finished_at: @clock_out.finished_at } }
    end

    assert_redirected_to clock_out_url(ClockOut.last)
  end

  test "should show clock_out" do
    get clock_out_url(@clock_out)
    assert_response :success
  end

  test "should get edit" do
    get edit_clock_out_url(@clock_out)
    assert_response :success
  end

  test "should update clock_out" do
    patch clock_out_url(@clock_out), params: { clock_out: { attendance_id: @clock_out.attendance_id, finished_at: @clock_out.finished_at } }
    assert_redirected_to clock_out_url(@clock_out)
  end

  test "should destroy clock_out" do
    assert_difference('ClockOut.count', -1) do
      delete clock_out_url(@clock_out)
    end

    assert_redirected_to clock_outs_url
  end
end
