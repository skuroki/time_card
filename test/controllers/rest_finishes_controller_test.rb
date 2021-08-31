require "test_helper"

class RestFinishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rest_finish = rest_finishes(:one)
  end

  test "should get index" do
    get rest_finishes_url
    assert_response :success
  end

  test "should get new" do
    get new_rest_finish_url
    assert_response :success
  end

  test "should create rest_finish" do
    assert_difference('RestFinish.count') do
      post rest_finishes_url, params: { rest_finish: { finished_at: @rest_finish.finished_at, rest_id: @rest_finish.rest_id } }
    end

    assert_redirected_to rest_finish_url(RestFinish.last)
  end

  test "should show rest_finish" do
    get rest_finish_url(@rest_finish)
    assert_response :success
  end

  test "should get edit" do
    get edit_rest_finish_url(@rest_finish)
    assert_response :success
  end

  test "should update rest_finish" do
    patch rest_finish_url(@rest_finish), params: { rest_finish: { finished_at: @rest_finish.finished_at, rest_id: @rest_finish.rest_id } }
    assert_redirected_to rest_finish_url(@rest_finish)
  end

  test "should destroy rest_finish" do
    assert_difference('RestFinish.count', -1) do
      delete rest_finish_url(@rest_finish)
    end

    assert_redirected_to rest_finishes_url
  end
end
