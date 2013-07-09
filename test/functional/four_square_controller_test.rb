require 'test_helper'

class FourSquareControllerTest < ActionController::TestCase
  test "should get venue_search" do
    get :venue_search
    assert_response :success
  end

  test "should get check_in" do
    get :check_in
    assert_response :success
  end

  test "should get post_rview" do
    get :post_rview
    assert_response :success
  end

end
