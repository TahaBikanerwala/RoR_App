require "test_helper"

class MicropostsInterface < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
    @another_user = users(:another_test)
    log_in_as(@user)
  end
end

class MicropostsInterfaceTest < MicropostsInterface
  test "micropost pagination" do
    get root_path
    assert_select "div.pagination"
  end

  test "invalid submission - should show errors and not create micropost" do
    # invalid submission
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "" } }
      assert_select "div#error_explanation"
    end
  end
  test "valid submission - should create micropost" do
    # valid submission
    content = "This micropost really ties the room together"
    assert_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end
  test "delete own micropost" do
    # Delete post
    get user_path(@user)
    assert_select "a", text: "Delete"
    first = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first)
    end
  end
  test "No Delete link for micropost of other user" do
    # Visit different user (no delete links)
    get user_path(@another_user)
    assert_select "a", text: "Delete", count: 0
  end
end
